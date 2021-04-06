require 'rails_helper'

RSpec.describe 'Items API' do
  before :each do
    4.times { create(:merchant_with_items, items_count: 30) }
    get '/api/v1/items'
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
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
      end
    end

    it 'defaults per page to 20' do

      expect(@items.length).to eq(20)
    end

    describe 'query params' do
      it 'can set per page' do
        get '/api/v1/items?per_page=10'
        ten_parsed = JSON.parse(response.body, symbolize_names: true)
        ten_data = ten_parsed[:data]

        expect(ten_data.length).to eq(10)
      end

      it 'can set the page number' do
        get '/api/v1/items?page=2'
        page_two_parsed = JSON.parse(response.body, symbolize_names: true)
        page_two_data = page_two_parsed[:data]
        first_item = Item.offset(20).first
        last_item = Item.offset(19).first

        expect(page_two_data.first[:id].to_i).to eq(first_item.id)
        expect(page_two_data.first[:id].to_i).to_not eq(last_item.id)
      end

      it 'still defaults per page to 20 when page is set' do
        get '/api/v1/items?page=2'
        page_two_parsed = JSON.parse(response.body, symbolize_names: true)
        page_two_data = page_two_parsed[:data]

        expect(page_two_data.length).to eq(20)
      end

      it 'can set per page and page number' do
        get '/api/v1/items?page=2&per_page=10'
        triple_p_parsed = JSON.parse(response.body, symbolize_names: true)
        triple_p_data = triple_p_parsed[:data]
        first_item = Item.offset(10).first
        last_item = Item.offset(9).first

        expect(triple_p_data.first[:id].to_i).to eq(first_item.id)
        expect(triple_p_data.first[:id].to_i).to_not eq(last_item.id)

        expect(triple_p_data.length).to eq(10)
      end
    end
  end
end