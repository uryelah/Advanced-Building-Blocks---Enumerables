#spec/enumerables_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:num_arr) { [2, 10, 1, 100, 12, -10] }
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
  end

  describe 'my_select' do
  end

  describe 'my_all?' do
    it 'Returns false if condition is not present in array' do
      expect(num_arr.my_all? { |e| e > 0 }).to be false
    end

    it 'Return true if condition is present in range' do
      expect((5..50).my_all?(Integer)).to be true
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