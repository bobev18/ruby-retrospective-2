class Integer
  def prime_divisors
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
    collect do |z|
      if z%3==0
        if z%5==0
          :fizzbuzz
        else
          :fizz
        end          
      elsif z%5==0
        :buzz
      else
        z
      end
    end
  end
end

class Hash
  def group_values
    result = {}
    self.keys.each do |k|
      unless result.has_key?(self.fetch(k))
        result[self.fetch(k)]=[]
      end
      result[self.fetch(k)]<<k  
    end
    result
  end
end

class Array
  def densities
    self.collect { |z| self.count(z) }
  end
end

p 0.prime_divisors
p 1.prime_divisors
p 4.prime_divisors
p 10.prime_divisors
p 36.prime_divisors
p 42.prime_divisors
p 17.prime_divisors
p -23.prime_divisors
num = -(2**31-1)
p num.prime_divisors
p num # check if object is replaced?
puts "="*10


p (1..6).fizzbuzz # [1, 2, :fizz, 4, :buzz, :fizz]
p (13...100).fizzbuzz # last is 99
range = (29..31)
p range.fizzbuzz
p range # to check if changed?
puts "="*12


p ({a: 1}).group_values             # {1 => [:a]}
p ({a: 1, b: 2, c: 1}).group_values # {1 => [:a, :c], 2 => [:b]}
hash = ({a: 5, b: 1, c: 2, baba: 1, dqdo: [], chushka: ({ami_sega: 1}), moje: 5, nqma: [],})
p hash.group_values
p hash
puts "="*15


p [:a, :b, :c].densities # [1, 1, 1]
p [:a, :b, :a].densities # [2, 1, 2]
p [:a, :a, :a].densities # [3, 3, 3]
ary = [:a, [], nil, 55, 's',:a,:a,:a,[],[],nil,]+'sssssss'.split('')
p ary.densities
p ary


