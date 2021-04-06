require 'rails_helper'

RSpec.describe 'merchant items request spec' do
  before :each do
    2.times {create(:merchant_with_items, items_count: 100)}

    get "/api/v1/merchants/#{Merchant.first.id}/items"
    parsed = JSON.parse(response.body, symbolize_names: true)
    @items = parsed[:data]
  end

  describe 'happy path' do
    it 'has a successful response' do

      expect(response).to be_successful
    end

    it 'sends the correct data' do

      @items.each do |item|
        expect(item).to have_key(:id)
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
      end
    end
  end
end