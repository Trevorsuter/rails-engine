require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { have_many :invoice_items }
    it { have_many(:invoices).through(:invoice_items) }
  end

  describe 'class methods' do
    before :each do
      @merchant = create(:merchant)
      @jack_hammer = @merchant.items.create(name: "Jack Hammer", description: "item1 description", unit_price: 1.00)
      @yarn = @merchant.items.create(name: "Yarn", description: "item2 description", unit_price: 10.00)
      @hungry_hippos = @merchant.items.create(name: "Hungry Hippos", description: "item3 description", unit_price: 20.00)
      @knife = @merchant.items.create(name: "Knife", description: "item4 description", unit_price: 30.00)
      @hockey_stick = @merchant.items.create(name: "Hockey Stick", description: "item5 description", unit_price: 30.00)
      @glasses = @merchant.items.create(name: "Glasses", description: "item6 description", unit_price: 40.00)
      @jungle_juice = @merchant.items.create(name: "Jungle Juice", description: "item7 description", unit_price: 40.50)
      @upper_computer_hardware = @merchant.items.create(name: "Computer Hardware", description: "item8 description", unit_price: 45.00)
      @lower_computer_hardware = @merchant.items.create(name: "computer hardware", description: "item9 description", unit_price: 47.50)  
    end

    it 'find_one_by_name' do
      expected = @yarn

      expect(Item.find_one_by_name("yarn")).to eq(expected)
    end

    it 'find_one_by_min_price' do
      expected = @upper_computer_hardware

      expect(Item.find_one_by_min_price(45)).to eq(expected)
    end

    it 'find_one_by_max_price' do
      expected = @jack_hammer

      expect(Item.find_one_by_max_price(5)).to eq(expected)
    end

    it 'find_one_by_price_range' do
      expected = @upper_computer_hardware

      expect(Item.find_one_by_price_range(42, 50)).to eq(expected)
    end
  end
end
