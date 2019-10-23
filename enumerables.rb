# frozen_string_literal: true

module Enumerable
  # rubocop:disable Style/RedundantSelf, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/For
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
      return true if yield(n)
    end
    false
  end

  def my_none?
    self.my_each do |n|
      return false if yield(n)
    end
    true
  end

  def my_count(item = nil)
    count = 0
    # if item.nil? && !block_given? return self.length end

    if !block_given?
      self.my_each do |n|
        count += 1 if n == item
      end
    elsif block_given?
      self.my_each do |n|
        count += 1 if yield(n)
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

  def my_inject(*args)
    memo = nil
    if args[0].is_a? Symbol
      initial = nil
      operation = args[0]
    else
      initial = args[0]
      operation = args[1]
    end
    if !block_given?
      case operation
      when :+
        memo = initial.nil? ? 0 : initial
        self.my_each do |n|
          memo += n
        end
        memo
      when :-
        memo = initial.nil? ? 0 : initial
        self.my_each do |n|
          memo -= n
        end
        memo
      when :*
        memo = initial.nil? ? 1 : initial
        self.my_each do |n|
          memo *= n
        end
        memo
      when :/
        memo = initial.nil? ? 1 : initial
        self.my_each do |n|
          memo /= n.to_f
        end
        memo
      end
      memo
      puts memo

    else
      memo = initial.nil? ? self[0] : initial
      self.my_each_with_index do |n, i|
        next if initial.nil? && i.zero?

        memo = yield(memo, n)
        return memo if i == self.length - 1
      end
      # return memo
    end
  end
  # rubocop:enable Style/RedundantSelf, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/For
end

puts [2,8,10].my_inject { |acc, cr|
  acc + cr
}