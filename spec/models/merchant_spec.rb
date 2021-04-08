require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'class methods' do
    before :each do
      @upper_turing = create(:merchant, name: "Turing School")
      @upper_ring_world = create(:merchant, name: "Ring World")
      @lower_turing = create(:merchant, name: "turing school")
      @lower_ring_world = create(:merchant, name: "ring world")
      @jack_hammer = create(:merchant, name: "Jack Hammer")
      @co_lift = create(:merchant, name: "Colorado Lift")
      @scileppis = create(:merchant, name: "Scileppi's")
      @sliceworks = create(:merchant, name: "Sliceworks")
      @homebot = create(:merchant, name: "HomeBot")
    end
    it 'find_all' do
      expected = [@upper_ring_world, @upper_turing, @lower_ring_world, @lower_turing]

      expect(Merchant.find_all_by_name("ring")).to eq(expected)
    end
  end
end
