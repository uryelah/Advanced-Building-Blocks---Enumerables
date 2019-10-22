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
    if item == nill
      return self.length
    
    end
  end

  def my_map
  
  end

  def my_inject
  
  end
end



puts [-1,-2,-3,-8,-4].my_none? { |n|
  n > 0
}

