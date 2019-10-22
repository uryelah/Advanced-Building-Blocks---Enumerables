# rubocop:disable Style/CaseEquality

# frozen_string_literal: true

module Enumerable
  def my_each
    for i in 0...self.length do
      yield(self[i])
    end
  end

  def my_each_with_index
    for i in 0...self.length do
      yield(self[i], i)
    end
  end

  def my_select
    new_arr = []
    self.my_each { |n|
      new_arr.push(n) if yield(n)
    }
    new_arr
  end

  def my_all?
    self.my_each { |n|
      if !yield(n)
        return false
      end
    }
    true
  end

  def my_any?
    self.my_each { |n|
      if yield(n)
        return true
      end
    }
    false
  end

  def my_none?
    self.my_each { |n|
      if yield(n)
        return false
      end
    }
    true
  end

  def my_count(item = nil)
    count = 0
    if item == nil && !block_given?
      return self.length
    elsif !block_given?
      self.my_each { |n|
        if n == item
          count += 1
        end
      }
    elsif block_given?
      self.my_each { |n|
        if yield(n)
          count += 1
        end
      }
    end
    count
  end

  def my_map(proc = nil)
    new_arr = []
    if proc 
      self.my_each { |n|
        new_arr.push(proc.call(n))
      }
    else
    self.my_each { |n|
      new_arr.push(yield(n))
    }
    new_arr
  end
  end

  def my_inject(initial = nil, operation = nil)
    memo = nil
    if initial.is_a? Symbol 
      operation, initial = initial, nil
    end
    if !block_given? 
      case operation
        when :+
          memo = initial == nil ? 0 : initial
          self.my_each { |n|
            memo += n
          }
          memo
        when :-
          memo = initial == nil ? 0 : initial
          self.my_each { |n|
            memo -= n
          }
          memo
        when :*
          memo = initial == nil ? 1 : initial
          self.my_each { |n|
            memo *= n
          }
          memo
        when :/
          memo = initial == nil ? 1 : initial
          self.my_each { |n|
            memo /= n.to_f
          }
          memo
      end
    else
      memo = initial == nil ? self[0] : initial
      self.my_each_with_index { |n, i|
        if initial.nil? && i == 0
          next
        else
          memo = yield(memo, n)
        end
      }
      memo
    end
  end
end

my_proc = Proc.new { |n|
  n ** 3
}

[1,2,3,4,5,100].my_inject(1,:*) { |acc, cr|
  acc - cr
}

def multiply_els (arr)
  arr.my_inject(:*)
end

puts multiply_els([2,4,5])

# rubocop:disable Style/CaseEquality