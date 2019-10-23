# frozen_string_literal: true

require './helpers.rb'

module Enumerable
  def my_each
    i = 0
    while i < length
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    new_arr = []
    my_each { |n| new_arr.push(n) if yield(n) }
    new_arr
  end

  def my_all?(pattern = nil)
    my_each { |n| return false unless n.to_s.match(pattern) } if pattern
    my_each { |n| return false unless yield(n) } unless pattern
    true
  end

  def my_any?(pattern = nil)
    my_each { |n| return true if n.to_s.match(pattern) } if pattern
    my_each { |n| return true if yield(n) } unless pattern
    false
  end

  def my_none?(pattern = nil)
    my_each { |n| return false if n.to_s.match(pattern) } if pattern
    my_each { |n| return false if yield(n) } unless pattern
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
