class Expr
  attr_accessor :tree

  def initialize(tree)
    @tree = tree
  end

  def self.build(tree)
    #initialize(tree)
    @tree = tree
  end

  def ==(other)
    return false if tree.size != other.size
    result = []
    tree.each_index do |i|
      if self[i].instance_of? Array then
        result.append( self.build(tree[i]) == self.build(other[i]) )
      else
        result.append(tree[i]==other[i])
      end
    end
    result.all?
  end

  def evaluate(env={})

  end
end

expr = Expr.build([:+, [:number, 1], [:*, [:number, 2], [:variable, :x]]])
expr2 = Expr.build([:+, [:number, 1], [:*, [:number, 2], [:variable, :x]]])
puts expr==expr2

