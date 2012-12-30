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
    result = []
    @tree.each_index do |i|
      if @tree[i].instance_of? Array then
        result << Expr.build(@tree[i]) == Expr.build(other.tree[i])
      else
        result << @tree[i]==other.tree[i]
      end
    end
    result.all?
  end

  def evaluate(env={})
    result = 0
    temp_tree = @tree.map do |i|
      if i.instance_of? Array and i[0] == :variable then
        [:number, env[i[1]]]
      elsif i.instance_of? Array then
        Expr.build(i).evaluate(env)
      else # if it's not Array, it's an operation
        i
      end
    end
    temp_tree
  end
end

expr = Expr.build([:+, [:number, 1], [:*, [:number, 2],[ :variable, :x]]])
expr2 = Expr.build([:+, [:number, 1], [:*, [:number, 2], [:variable, :x]]])
puts expr==expr2
p expr.instance_of? Array
p expr.evaluate(x: 2)
p Expr.parse('x * 2 + y').evaluate(x: 3, y: 4) # => 10

