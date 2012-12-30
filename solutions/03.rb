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

  def mysimplify(tree)
    case tree[0]
      when :variable, :number then tree
      when :*
        if mysimplify(tree[1])==[:number, 0] or mysimplify(tree[2])==[:number, 0] then [:number, 0]
        elsif mysimplify(tree[1])==[:number, 1] then mysimplify(tree[2])
        elsif mysimplify(tree[2])==[:number, 1] then mysimplify(tree[1])
        elsif mysimplify(tree[1])[0]==:number and mysimplify(tree[2])[0]==:number then
          [:number, mysimplify(tree[1])[1] * mysimplify(tree[2])[1]]
        else [:*, mysimplify(tree[1]), mysimplify(tree[2])]
        end
      when :+
        if mysimplify(tree[1])==[:number, 0] then mysimplify(tree[2])
        elsif mysimplify(tree[2])==[:number, 0] then mysimplify(tree[1])
        elsif mysimplify(tree[1])[0]==:number and mysimplify(tree[2])[0]==:number then
          [:number, mysimplify(tree[1])[1] + mysimplify(tree[2])[1]]
        else [:+, mysimplify(tree[1]), mysimplify(tree[2])]
        end
      when :sin
        if mysimplify(tree[1])==[:number, 0] then [:number, 0]
        else [:sin, mysimplify(tree[1])]
        end
      else
        [tree[0], mysimplify(tree[1])] # :- and :cos
    end
  end

  def simplify
    Expr.build(mysimplify(@tree))
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

expr = Expr.build([:+, [:number, 1], [:*, [:number, 2],[ :variable, :x]]])
expr2 = Expr.build([:+, [:number, 1], [:*, [:number, 2], [:variable, :x]]])
p "tree",expr.tree
puts expr==expr2
p expr.instance_of? Array
p "tree",expr.tree
p expr.evaluate(x: 2)
p Expr.parse('x * 2 + y').evaluate(x: 3, y: 4) # => 10

p Expr.parse('x + 0').simplify
p Expr.parse('1 * x + x * 1').simplify
p "-"*10
p Expr.parse('x * x').derive(:x) #        => Expr.parse('x + x')
p Expr.parse('2 * x + 3 * y').derive(:y)# => Expr.parse('3')
p Expr.parse('sin(x)').derive(:x) #       => Expr.parse('cos(x)')