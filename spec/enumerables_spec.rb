#spec/enumerables_spec.rb

require './enumerables.rb'

RSpec.describe Enumerable do
  let(:num_arr) { [2, 10, 1, 100, 12, -10] }
  let(:str_arr) { ['2', '10', '1', '100', '12', '-10'] }

  describe 'my_each' do
    empty_str = ''

    it 'Returns an enumerator unless a block is given' do
      expect(num_arr.my_each).to be_kind_of(Enumerator)
    end

    it 'Puts each item of the enumerable object if a block is given' do
      str_arr.my_each { |n| empty_str += n }
      expect(empty_str).to eql('210110012-10')
    end
  end

  describe "my_each_with_index" do
  end

  describe "my_select" do
  end

  describe "my_all?" do
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
