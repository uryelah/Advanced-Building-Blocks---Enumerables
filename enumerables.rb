# frozen_string_literal: true

module Enumerable
  # rubocop:disable Style/RedundantSelf, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_each
    i = 0
    while i < self.length
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < self.length
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    new_arr = []
    self.my_each { |n| new_arr.push(n) if yield(n) }
    new_arr
  end

  def my_all?
    self.my_each { |n| return false unless yield(n) }
    true
  end

  def my_any?
    self.my_each { |n| return true if yield(n) }
    false
  end

  def my_none?
    self.my_each { |n| return false if yield(n) }
    true
  end

  def my_count(item = nil)
    count = 0
    return self.length if item.nil? && !block_given?

    if !block_given?
      self.my_each { |n| count += 1 if n == item }
    elsif block_given?
      self.my_each { |n| count += 1 if yield(n) }
    end
    count
  end

  def my_map(proc = nil)
    new_arr = []
    if proc
      self.my_each { |n| new_arr.push(proc.call(n)) }
    else
      self.my_each { |n| new_arr.push(yield(n)) }
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
        self.my_each { |n| memo += n }
        memo
      when :-
        memo = initial.nil? ? 0 : initial
        self.my_each { |n| memo -= n }
        memo
      when :*
        memo = initial.nil? ? 1 : initial
        self.my_each { |n| memo *= n }
        memo
      when :/
        memo = initial.nil? ? 1 : initial
        self.my_each { |n| memo /= n.to_f }
        memo
      end
    else
      memo = initial.nil? ? self[0] : initial
      self.my_each_with_index do |n, i|
        next if initial.nil? && i.zero?

        memo = yield(memo, n)
        return memo if i == self.length - 1
      end
    end
  end
  # rubocop:enable Style/RedundantSelf, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
