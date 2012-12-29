class Integer
  def prime_divisors
    # Changed to make it easier to understand
    num = self.abs
    result, div = [],1
    while num>1
      div += 1
      if num%div==0 then result << div and num/=div end
      if div > Math.sqrt(num) then div = num-1 end
    end
    result.uniq
  end
end

class Range
  def fizzbuzz
    # actually this is the method code I have posted, and the one that I had in the initial commit is
    #    the result of my attempt to adhere to the suggestion in the comments:
    #    fizzbuzz-а ти е сложен. Трите тернарни оператора са много гадни за четене. По-добре да го беше направил с if/else
    #    I will change it again, as I dont like the potcome of the if/else approach
    collect { |z| (z%3==0 and z%5==0) ? :fizzbuzz : (z%3==0 ? :fizz : (z%5==0 ? :buzz : z)) }
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