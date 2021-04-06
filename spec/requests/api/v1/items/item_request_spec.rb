require 'rails_helper'

RSpec.describe 'Item show API' do
  before :each do
    create(:merchant_with_items, items_count: 10)
    get "/api/v1/items/#{Item.first.id}"
    parsed = JSON.parse(response.body, symbolize_names: true)
    @item = parsed[:data]
  end

  describe 'happy path' do
    it 'has a successful response' do

      expect(response).to be_successful
    end

    it 'shows the correct item' do

      expect(@item[:id].to_i).to eq(Item.first.id)
    end

    it 'only shows one item' do
      
      expect(@item).to_not be_an(Array)
    end

    it 'shows the items data correctly' do

      expect(@item).to have_key(:id)
      expect(@item).to have_key(:attributes)

      expect(@item[:attributes]).to have_key(:name)
      expect(@item[:attributes]).to have_key(:description)
      expect(@item[:attributes]).to have_key(:unit_price)
      expect(@item[:attributes]).to have_key(:merchant_id)
    end
  end
end