# frozen_string_literal: true

# rubocop:disable Style/CaseEquality

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
    self.my_each do |n|
      new_arr.push(n) if yield(n)
    end
    new_arr
  end

  def my_all?
    self.my_each do |n|
      return false unless yield(n)
    end
    true
  end

  def my_any?
    self.my_each do |n|
      if yield(n)
        return true
      end
    end
    false
  end

  def my_none?
    self.my_each do |n|
      if yield(n)
        return false
      end
    end
    true
  end

  def my_count(item = nil)
    count = 0
    if item == nil && !block_given?
      return self.length
    elsif !block_given?
      self.my_each do |n|
        if n == item
          count += 1
        end
      end
    elsif block_given?
      self.my_each do |n|
        if yield(n)
          count += 1
        end
      end
    end
    count
  end

  def my_map(proc = nil)
    new_arr = []
    if proc 
      self.my_each do |n|
        new_arr.push(proc.call(n))
      end
    else
    self.my_each do |n|
      new_arr.push(yield(n))
    end
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
          self.my_each do |n|
            memo += n
          end
          memo
        when :-
          memo = initial == nil ? 0 : initial
          self.my_each do |n|
            memo -= n
          end
          memo
        when :*
          memo = initial == nil ? 1 : initial
          self.my_each do |n|
            memo *= n
          end
          memo
        when :/
          memo = initial == nil ? 1 : initial
          self.my_each do |n|
            memo /= n.to_f
          end
          memo
      end
    else
      memo = initial == nil ? self[0] : initial
      self.my_each_with_index do |n, i|
        if initial.nil? && i == 0
          next
        else
          memo = yield(memo, n)
        end
      end
      memo
    end
  end
end

puts [1,2,3,4].my_all? { |n|
  n >= 1
}

# rubocop:disable Style/CaseEquality