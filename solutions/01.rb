class Integer
  def prime_divisors
    # Changed to make it easier to read/understand
    # I can use div=divisor, num=divident, but the current ones seem meaningful enough 
    result, div, num = [], 1, abs
    while num>1
      div += 1
      while num%div==0
        result << div and num/=div 
      end
      div = num-1 if div > Math.sqrt(num)
    end
    result.uniq
  end
end

class Range
  def fizzbuzz
    # OK, I took that one from Петко Борджуков, but it's the texbook example - it cannot be improved
    map do |divident|
      next :fizzbuzz if divident % 15 == 0
      next :buzz     if divident %  5 == 0
      next :fizz     if divident %  3 == 0
      divident
    end
  end
end

class Hash
  def group_values
    result = {}
    keys.each do |k|
      unless result.has_key?(fetch(k))
        result[fetch(k)]=[]
      end
      result[fetch(k)] << k
    end
    result
  end
end

class Array
  def densities
    collect { |z| self.count(z) }
  end
end