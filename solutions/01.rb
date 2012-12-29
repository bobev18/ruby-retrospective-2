class Integer
  def prime_divisors
    worknumber, result, div = self.abs, [], 1
    while worknumber>1 and div+=1
      result << div and worknumber/=div while worknumber%div==0
      div = worknumber-1 if div > Math.sqrt(worknumber)
    end
    result.uniq
  end
end

class Range
  def fizzbuzz
    result = self.collect { |z| (z%3==0 and z%5==0) ? :fizzbuzz : (z%3==0 ? :fizz : (z%5==0 ? :buzz : z)) }
    #result = result.each { |z| z.integer? and z%3==0 ? :fizz : z }
    #result = result.each { |z| z.integer? and z%5==0 ? :buzz : z }
  end
end

class Hash
  def group_values
    result = {}
    self.keys.each { |k| result.has_key?(self[k]) ? result[self[k]]<<k : result[self[k]]=[k] }
    result
  end
end

class Array
  def densities
    self.collect { |z| self.count(z) }
  end
end