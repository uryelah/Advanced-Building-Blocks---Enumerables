#spec/enumerables_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:num_arr) { [2, 10, 1, 100, 12, -10] }
  let(:falsy_arr) { [nil, 10, 1, 100, 12, -10] }
  let(:false_arr) { [nil, false, nil, false, false] }
  let(:truthy_arr) { [nil, false, 1, false, nil, nil] }
  let(:equal_arr) { [100, 100, 100] }
  let(:str_arr) { ['2', '10', '1', 'House', '12', '-10'] }
  let(:comb_arr) { [2, 10, '1', 'House', 12, 'LOL'] }
  let(:sym_same_arr) { %i[1 1 1] }
  let(:sym_dif_arr) { %i[2 b 1] }
  let(:range) { (1..5) }
  let(:hash) { { a: 1, b: 2, c: 3 } }
  one_symbol = '1'.to_sym
  two_symbol = '2'.to_sym

  describe 'my_each' do
    it 'Returns an enumerator unless a block is given' do
      expect(num_arr.my_each).to be_kind_of(Enumerator)
    end

    it 'Should call the given block for each element in the enumerable object' do
      passed_block_counter = 0
      my_proc = proc { passed_block_counter += 1 }
      range.my_each { my_proc.call }
      expect(passed_block_counter).to eql(range.size)
    end

    it 'Should call the given block for each element and accept the item as it\'s only parameter' do
      empty_str = ''
      range.my_each { |n| empty_str += n.to_s }
      expect(empty_str).to eql('12345')
    end

    it 'Should return itself if given a block' do
      expect(num_arr.my_each { |n| n }).to eql(num_arr)
    end

    it 'Should work with ranges' do
      expect(range.my_each { |_e| }).to eql(range)
    end

    it 'Should accept hash\'s keys and values as parameters if block given' do
      empty_str = ''
      hash.my_each { |key, val| empty_str += key.to_s + val.to_s }
      expect(empty_str).to eql('a1b2c3')
    end
  end

  describe 'my_each_with_index' do
    it 'Returns an enumerator unless a block is given' do
      expect(num_arr.my_each_with_index).to be_kind_of(Enumerator)
    end

    it 'Should yield the given block for each element in the enumerable object' do
      passed_block_counter = 0
      my_proc = proc { passed_block_counter += 1 }
      range.my_each { my_proc.call }
      expect(passed_block_counter).to eql(range.size)
    end

    it 'Should work with ranges' do
      expect(range.my_each_with_index { |_e, _i| }).to eql(range)
    end

    it 'Should yield the given block for each element and accept the index as a parameter' do
      passed_block_counter = 0
      my_proc = proc { |i| passed_block_counter = i }
      range.my_each_with_index { |_b, i| my_proc.call(i) }
      expect(passed_block_counter).to be(range.size - 1)
    end

    it 'Should call the given block for each element and accept two parameters, the item and it\'s index' do
      empty_str = ''
      range.my_each_with_index { |n, i| empty_str += n.to_s + i.to_s }
      expect(empty_str).to eql('1021324354')
    end

    it 'Should return itself if given a block' do
      expect(num_arr.my_each_with_index { |n| n }).to eql(num_arr)
    end

    it 'Should accept hash\'s keys and values as parameters if block given' do
      empty_str = ''
      hash.my_each_with_index { |key, val, i| empty_str += key.to_s + val.to_s + i.to_s }
      expect(empty_str).to eql('[:a, 1]0[:b, 2]1[:c, 3]2')
    end
  end

  describe 'my_select' do
    it 'Returns an enumerator unless a block is given' do
      expect(num_arr.my_select).to be_kind_of(Enumerator)
    end

    it 'Returns an array when block is given' do
      expect(hash.my_select { |_e| }).to eql([])
    end

    it 'Returns an array with selected elements when a block is given' do
      expect(comb_arr.my_select { |e| e.is_a? String }).to eql(%w[1 House LOL])
    end

    it 'Returns the given enum when the block returns something else than true or false' do
      expect(comb_arr.my_select { |e| e }).to eql(comb_arr)
    end
  end

  describe 'my_all?' do
    it 'Should return false if one of the items is falsy and no block or parameter were given' do
      expect(falsy_arr.my_all?).to be false
    end

    it 'Should return true if none of the items is falsy and no block or parameter were given' do
      expect(num_arr.my_all?).to be true
    end

    it 'Returns false if one element doesn\'t pass the condition with block given in enumerable' do
      expect(num_arr.my_all? { |e| e > 0 }).to be false
    end

    it 'Returns true if all elements pass the condition with block given in enumerable' do
      expect(num_arr.my_all? { |e| e < 1000 }).to be true
    end

    it 'Should return false if one the items in the enum is not
    equal to the parameter and parameter is not a Class or a RegExp and no block was given' do
      expect(num_arr.my_all?(200)).to be false
    end

    it 'Should return true if all the items in the enum are equal
    to the parameter and parameter is not a Class or a RegExp and no block was given' do
      expect(equal_arr.my_all?(100)).to be true
    end

    it 'Returns false if an item of an array is not an instance of the same Class and no block was given' do
      expect(falsy_arr.my_all?(Integer)).to be false
    end

    it 'Return true if all items in enum are the instances of the same Class and no block was given' do
      expect((5..50).my_all?(Integer)).to be true
    end

    it 'Returns true if all the items of a hash are the same Symbol as the given parameter and no block was given' do
      expect(sym_same_arr.my_all?(one_symbol)).to be true
    end

    it 'Returns false if an item of a hash is not the same Symbol as the given parameter and no block was given' do
      expect(sym_dif_arr.my_all?(one_symbol)).to be false
    end

    it 'Returns true if all items of enum match the RegExp parameter and no block was given' do
      expect(num_arr.my_all?(/\d/)).to be true
    end

    it 'Returns false if an item of enum does not match the RegExp parameter and no block was given' do
      expect(falsy_arr.my_all?(/\d/)).to be false
    end
  end

  describe 'my_any?' do
    it 'Should return false if none of the items are truthy and no block or parameter were given' do
      expect(false_arr.my_any?).to be false
    end

    it 'Should return true if at least one of the items is truthy and no block or parameter were given' do
      expect(truthy_arr.my_any?).to be true
    end

    it 'Returns false if none elements pass the condition with block given in enumerable' do
      expect(num_arr.my_any? { |e| e > 200 }).to be false
    end

    it 'Returns true if at least one element pass the condition with block given in enumerable' do
      expect(num_arr.my_any? { |e| e < 0}).to be true
    end

    it 'Should return false if none of the items in the enum is
    equal to the parameter and parameter is not a Class or a RegExp and no block was given' do
      expect(num_arr.my_any?(200)).to be false
    end

    it 'Should return true if at least one of the items in the enum are equal
    to the parameter and parameter is not a Class or a RegExp and no block was given' do
      expect(equal_arr.my_any?(100)).to be true
    end

    it 'Returns false if none of the items of an enum is an instance of the same Class and no block was given' do
      expect(num_arr.my_any?(String)).to be false
    end

    it 'Returns true if at least one item in enum is an instance of the same Class and no block was given' do
      expect(truthy_arr.my_any?(Integer)).to be true
    end

    it 'Returns true if at least one item of a hash is the same Symbol as the given parameter and no block was given' do
      expect(sym_dif_arr.my_any?(one_symbol)).to be true
    end

    it 'Returns false if none of the items of a hash is not the same Symbol as the given parameter and no block was given' do
      expect(sym_same_arr.my_any?(two_symbol)).to be false
    end

    it 'Returns true if at least one item of enum matches the RegExp parameter and no block was given' do
      expect(truthy_arr.my_any?(/\d/)).to be true
    end

    it 'Returns false if none of the items of enum matches the RegExp parameter and no block was given' do
      expect(falsy_arr.my_any?(/zzz/)).to be false
    end
  end

  describe 'my_none?' do
    it 'Should return false if one of the items is truthy and no block or parameter were given' do
      expect(truthy_arr.my_none?).to be false
    end

    it 'Should return true if all of the items are falsy and no block or parameter were given' do
      expect(false_arr.my_none?).to be true
    end

    it 'Returns false if one element passes the condition with block given in enumerable' do
      expect(num_arr.my_none? { |e| e < 0 }).to be false
    end

    it 'Returns true if all elements don\'t pass the condition with block given in enumerable' do
      expect(num_arr.my_none? { |e| e > 1000 }).to be true
    end

    it 'Should return false if one the items in the enum is
    equal to the parameter and parameter is not a Class or a RegExp and no block was given' do
      expect(num_arr.my_none?(100)).to be false
    end

    it 'Should return true if none of the items in the enum are equal
    to the parameter and parameter is not a Class or a RegExp and no block was given' do
      expect(equal_arr.my_none?(200)).to be true
    end

    it 'Returns false if an item of an array is an instance of the same Class given as parameter and no block was given' do
      expect(truthy_arr.my_none?(Integer)).to be false
    end

    it 'Return true if all items in enum aren\'t instances of the same Class given as parameter and no block was given' do
      expect((5..50).my_none?(String)).to be true
    end

    it 'Returns true if none the items of a hash are the same Symbol as the given parameter and no block was given' do
      expect(sym_same_arr.my_none?(two_symbol)).to be true
    end

    it 'Returns false if an item of a hash is the same Symbol as the given parameter and no block was given' do
      expect(sym_dif_arr.my_none?(two_symbol)).to be false
    end

    it 'Returns true if none of the items of enum match the RegExp parameter and no block was given' do
      expect(num_arr.my_none?(/lol/)).to be true
    end

    it 'Returns false if an item of enum matches the RegExp parameter and no block was given' do
      expect(falsy_arr.my_none?(/\d/)).to be false
    end
  end

  describe 'my_count' do
    it 'Should return the number of elements in the enum as an Integer if no parameter or block are given' do
      expect(equal_arr.my_count).to eql(3)
    end

    it 'Should return the number of elements in the enum that are equal to the given parameter as an Integer' do
      expect(truthy_arr.my_count(1)).to eql(1)
    end

    it 'Should return the number of elements in the enum that are equal to the given parameter as an Integer' do
      expect(str_arr.my_count { |e| e.length > 2 }).to eql(2)
    end

    it 'Should return the number of elements in the enum that are equal to the given parameter if a parameter and a block are given' do
      expect(num_arr.my_count(100) { |e| e.length > 2 }).to eql(1)
    end

    it 'Should return the number of elements in the enum that are equal to the given parameter if a parameter and a block are given' do
      expect(num_arr.my_count(Integer)).to eql(0)
    end

    it 'Should return the number of elements in the enum that are equal to the given parameter if a parameter and a block are given' do
      expect((1..10).my_count).to eql(10)
    end

    it 'Should return the number of elements in the enum that are equal to the given parameter if a parameter and a block are given' do
      expect((1..10).my_count).to eql(10)
    end
  end

  describe 'my_map' do
    it 'Should return an enumerator unless a block is given' do
      expect(num_arr.my_map).to be_kind_of(Enumerator)
    end

    it 'Should return a new array with it\'s elements mutated by the block given' do
      expect(num_arr.my_map { |e| e**2 }).to eql([4, 100, 1, 10_000, 144, 100])
    end

    it 'Should return an array including each element in a range when a block is given' do
      expect(range.my_map { |e| e }).to eql([1, 2, 3, 4, 5])
    end

    it 'Should return an array of arrays, each containing a key value pair, if used with a hash and block is given just returning the hash pair' do
      expect(hash.my_map { |e| e }).to eql([[:a, 1], [:b, 2], [:c, 3]])
    end

    it 'Should be able to access both the key and value from a hash if the block given has two parameters' do
      expect(hash.my_map { |key, val| [key.to_s, val * 2] }).to eql([['a', 2], ['b', 4], ['c', 6]])
    end

    it 'Should be able to use array methods and operations to parameter inside block if only one parameter is given' do
      expect(hash.my_map { |e| e * 2 }).to eql([[:a, 1, :a, 1], [:b, 2, :b, 2], [:c, 3, :c, 3]])
    end

    it 'Should be able to use array methods and operations to parameter inside block if only one parameter is given' do
      expect(hash.my_map { |e| e + [2] }).to eql([[:a, 1, 2], [:b, 2, 2], [:c, 3, 2]])
    end
  end

  describe 'my_inject' do
    it 'Should return an accumulator that combines all elements of enum when just a symbol is given, in an array' do
      expect(num_arr.my_inject(:+)).to eql(115)
    end

    it 'Should return an accumulator that combines all elements of enum when just a symbol is given, in a range' do
      expect(range.my_inject(:+)).to eql(15)
    end

    it 'Should return an accumulator that combines all elements of enum when a start value and symbol are given, in an array' do
      expect(num_arr.my_inject(3, :+)).to eql(118)
    end

    it 'Should return an accumulator that combines all elements of enum when a start value and symbol are given, in a range' do
      expect(range.my_inject(3, :+)).to eql(18)
    end

    it 'Should return an accumulator that combines all elements of enum when a start value and symbol are given, in a range' do
      expect(str_arr.my_inject('mama', :+)).to eql('mama2101House12-10')
    end

    it 'Should return an accumulator that combines all elements of enum when a block is given with no parameters' do
      expect(range.my_inject { |acc, e| acc * e }).to eql(120)
    end

    it 'Should return an accumulator that combines all elements of enum when a block is given with no parameters' do
      expect(range.my_inject(3) { |acc, e| acc * e }).to eql(360)
    end

    it 'Should return an accumulator that combines all elements and start value of enum when a block and a start value is given' do
      expect(range.my_inject(3) { |acc, e| acc * e }).to eql(360)
    end

    it 'Should return an accumulator that combines all elements
    and start value ignoring the block when start value and symbol are given' do
      expect(range.my_inject(3, :+) { |acc, e| acc * e }).to eql(18)
    end

    it 'Should return an accumulator (array) that combines all pairs in a hash
  when a block with no parameters' do
      expect(hash.my_inject { |acc, e | acc + e }).to eql(hash.to_a.flatten)
    end

    it 'Should return an accumulator that combines all elements
    and start value ignoring the block when start value and symbol are given' do
      expect(hash.my_inject { |acc, e| acc + e }).to eql(hash.to_a.flatten)
    end

    it 'Should return an accumulator that combines all elements
    and start value ignoring the block when start value and symbol are given' do
      expect(range.my_inject {}).to eql(nil)
    end
  end
end

=begin
it 'Puts each item of the array if a block is given' do
  empty_str = ''
  str_arr.my_each { |n| empty_str += n }
  expect(empty_str).to eql('210110012-10')
end

it 'Puts each item of the range if a block is given' do
  empty_str = ''
  range.my_each { |n| empty_str += n.to_s }
  expect(empty_str).to eql('12345')
end

it 'Puts each item of the hash if a block is given' do
  empty_str = ''
  hash.my_each { |key, val| empty_str += key.to_s + val.to_s }
  expect(empty_str).to eql('a1b2c3')
end
=end