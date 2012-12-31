require 'treetop'
Treetop.load 'parser'

class Expr
  attr_accessor :tree

  def initialize(tree)
    @tree = tree
  end

  #--------------- remove -----------------
  def self.parse(input)
    new ArithmeticParser.new.parse(input).to_sexp
  end
  # ---------------------------------------

  def self.build(tree)
    new tree
  end

  def ==(other)
    return false if @tree.size != other.tree.size
    @tree.flatten == other.tree.flatten
  end

  def evaluate(env={})
    case @tree[0]
      when :variable then env[@tree[1]]
      when :number   then @tree[1]
      when :*        then Expr.build(@tree[1]).evaluate(env)*Expr.build(@tree[2]).evaluate(env)
      when :+        then Expr.build(@tree[1]).evaluate(env)+Expr.build(@tree[2]).evaluate(env)
      when :-        then -Expr.build(@tree[1]).evaluate(env)
      when :sin      then Math.sin Expr.build(@tree[1]).evaluate(env)
      when :cos      then Math.cos Expr.build(@tree[1]).evaluate(env)
    end
  end

  def do_siplify(tree,o)
    p1, p2 = my_simplify(tree[1]), my_simplify(tree[2])
    if o and p1==[:number, 0] or p2==[:number, 0] then [:number, 0]
    elsif o and p1==[:number, 1] then p2
    elsif o and p2==[:number, 1] then p1
    elsif o and p1[0]==:number and p2[0]==:number then [:number, p1[1] * p2[1]]
    elsif o then [:*, p1, p2]
    elsif not o and p1==[:number, 0] then p2
    elsif not o and p2==[:number, 0] then p1
    elsif not o and p1[0]==:number and p2[0]==:number then [:number, p1[1] + p2[1]]
    elsif not o then [:+, p1, p2] end
  end

  def my_simplify(tree)
    case tree[0]
      when :variable, :number then tree
      when :* then do_siplify(tree,true)
      when :+ then do_siplify(tree,false)
      when :sin
        if my_simplify(tree[1])==[:number, 0] then [:number, 0]
        else [:sin, my_simplify(tree[1])]
        end
      else
        [tree[0], my_simplify(tree[1])] # :- and :cos
    end
  end

  def simplify
    Expr.build(my_simplify(@tree))
  end

  def md(variable)
    case @tree[0]
      when :variable then @tree[1] == variable ? [:number, 1] : [:number, 0]
      when :number   then [:number, 0]
      when :*
        a = [:*, Expr.build(@tree[1]).md(variable), @tree[2]]
        b = [:*, @tree[1], Expr.build(@tree[2]).md(variable)]
        [:+, a, b]
      when :+
        [:+, Expr.build(@tree[1]).md(variable), Expr.build(@tree[2]).md(variable)]
      when :-        then [:-, Expr.build(@tree[1]).md(variable)]
      when :sin      then [:*, Expr.build(@tree[1]).md(variable), [:cos, @tree[1]]]
      when :cos      then [:*, Expr.build(@tree[1]).md(variable), [:-, [:sin, @tree[1]]]]
    end
  end

  def derive(variable)
    Expr.build(md(variable)).simplify
  end
end