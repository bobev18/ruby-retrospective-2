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

  def simplify
    case @tree[0]
      when :* then 
        if Expr.build(@tree[1]).simplify==Expr.build([:number, 0]) or 
            Expr.build(@tree[2]).simplify==Expr.build([:number, 0]) then
            Expr.build([:number, 0])
        elsif Expr.build(@tree[1]).simplify==Expr.build([:number, 1]) then
          Expr.build(@tree[2]).simplify
        elsif Expr.build(@tree[2]).simplify==Expr.build([:number, 1]) then
          Expr.build(@tree[1]).simplify
        else self
        end
      when :+ then 
        if Expr.build(@tree[1]).simplify==Expr.build([:number, 0]) then Expr.build(@tree[2]).simplify
        elsif Expr.build(@tree[2]).simplify==Expr.build([:number, 0]) then Expr.build(@tree[1]).simplify
        else self
        end
      when :sin then Expr.build(@tree[1]).simplify == Expr.build([:number, 0]) ? Expr.build([:number, 0]) : @tree
      else self
    end 
  end

  def derive
    #not implemented
  end

end

expr = Expr.build([:+, [:number, 1], [:*, [:number, 2],[ :variable, :x]]])
expr2 = Expr.build([:+, [:number, 1], [:*, [:number, 2], [:variable, :x]]])
p "tree",expr.tree
puts expr==expr2
p expr.instance_of? Array
p "tree",expr.tree
p expr.evaluate(x: 2)
p Expr.parse('x * 2 + y').evaluate(x: 3, y: 4) # => 10

p Expr.parse('x + 0').simplify