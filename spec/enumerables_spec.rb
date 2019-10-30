#spec/enumerables_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:num_arr) { [2, 10, 1, 100, 12, -10] }
  let(:falsy_arr) { [nil, 10, 1, 100, 12, -10] }
  let(:equal_arr) { [100, 100, 100] }
  let(:str_arr) { ['2', '10', '1', '100', '12', '-10'] }
  let(:range) { (1..5) }
  let(:hash) { { a: 1, b: 2, c: 3 } }

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
  end

  describe 'my_all?' do
    it 'Should return false if one of the items is falsy ' do
      expect(falsy_arr.my_all?).to be false
    end

    it 'Should return true if none of the items is falsy ' do
      expect(num_arr.my_all?).to be true
    end

    it 'Should return false if one the items in the enum is not equal to the parameter and parameter is not a Class or a RegExp' do
      expect(num_arr.my_all?(200)).to be false
    end
    
    it 'Should return true if one the items in the enum is not equal to the parameter and parameter is not a Class or a RegExp' do
      expect(equal_arr.my_all?(100)).to be true
    end

    it 'Returns false if one element doesn\'t pass the condition with block given in enumerable' do
      expect(num_arr.my_all? { |e| e > 0 }).to be false
    end

    it 'Returns true if one element doesn\'t pass the condition with block given in enumerable' do
      expect(num_arr.my_all? { |e| e < 1000 }).to be true
    end

    it 'Returns false if an item of an array is not from the same class' do
      expect(falsy_arr.my_all?(Integer)).to be false
    end
    
    it 'Return true if all items in enum are the instances of the same class' do
      expect((5..50).my_all?(Integer)).to be true
    end

    it 'Returns false if an item of a hash is not from the same class' do
      expect(hash.my_all?(Symbol)).to be false
    end
    
    it 'Returns true if an item of enum does not match the RegExp' do
      expect(num_arr.my_all?(/\d/)).to be true
    end

    it 'Returns false if an item of enum does not match the RegExp' do
      expect(falsy_arr.my_all?(/\d/)).to be false
    end

  end

  describe "my_any?" do
  end

  describe "my_none?" do
  end

  describe "my_count" do
  end

  describe "my_map" do
  end

  describe "my_inject" do
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