require 'treetop'
Treetop.load 'parser'

class Expr
  attr_accessor :tree

  def initialize(tree)
    @tree = tree
  end

  #--------------- remove -----------------
  def self.parse(input)
    Expr.new ArithmeticParser.new.parse(input).to_sexp
  end
  # ---------------------------------------

  def self.build(tree)
    #initialize(
    #@tree = tree
    Expr.new tree
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
end

expr = Expr.build([:+, [:number, 1], [:*, [:number, 2],[ :variable, :x]]])
expr2 = Expr.build([:+, [:number, 1], [:*, [:number, 2], [:variable, :x]]])
puts expr==expr2
p expr.instance_of? Array
p expr.evaluate(x: 2)
p Expr.parse('x * 2 + y').evaluate(x: 3, y: 4) # => 10

