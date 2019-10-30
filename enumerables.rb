# frozen_string_literal: true

require './helpers.rb'

module Enumerable
  def my_each
    new_arr = [] unless block_given?
    i = 0
    a = Array self
    while i < a.size
      yield(a[i]) if block_given?
      new_arr << a[i] unless block_given?
      i += 1
    end
    return Enumerator.new(new_arr) unless block_given?

    self
  end

  def my_each_with_index
    new_arr = [] unless block_given?
    i = 0
    while i < size
      yield(self[i], i) if block_given?
      new_arr << self[i] unless block_given?
      i += 1
    end
    return Enumerator.new(new_arr) unless block_given?

    self
  end

  def my_select
    return my_each unless block_given?

    new_arr = []
    my_each { |n| new_arr.push(n) if yield(n) }
    new_arr
  end

  def my_all?(pattern = nil)
    if block_given?
      my_each { |n| return false unless yield(n) }
    elsif pattern
      my_each { |n| return false unless case_checker(n, pattern) }
    else
      my_each { |n| return false unless n }
    end
    true
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |n| return true if yield(n) }
    elsif pattern
      my_each { |n| return true if any_checker(n, pattern) }
    else
      my_each { |n| return true if n }
    end
    false
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each { |n| return false if yield(n) }
    elsif pattern
      my_each { |n| return false if case_checker(n, pattern) }
    else
      my_each { |n| return false if n }
    end
    true
  end

  def my_count(item = false)
    count = 0

    if !block_given?
      return length unless item

      my_each { |n| count += 1 if n == item }
    elsif block_given?
      my_each { |n| count += 1 if yield(n) }
    end
    count
  end

  def my_map(proc = nil)
    new_arr = []
    if proc
      my_each { |n| new_arr.push(proc.call(n)) }
    else
      my_each { |n| new_arr.push(yield(n)) } if block_given?
      my_each { |n| new_arr << n } unless block_given?
      new_arr = Enumerator.new(new_arr) unless block_given?
      new_arr
    end
  end

  def my_inject(*args)
    memo = nil
    if oop?(args[0])
      initial = args[1]
      operation = args[0]
      memo = initial
    elsif args[0]
      initial = args[0]
      operation = args[1]
      memo = initial
    end
    if block_given?
      my_each do |n|
        memo && memo = yield(memo, n)
        memo ||= n
      end
    else
      memo = nil_asign(operation, memo)
      my_each { |n| memo = oop_eval(memo, n, operation) }
    end
    memo
  end
end
