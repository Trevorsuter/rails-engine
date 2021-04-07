require 'rails_helper'

RSpec.describe 'Items API' do

  before :each do
    4.times { create(:merchant_with_items, items_count: 30) }
  end

  describe 'happy path' do
    describe 'get' do
      before :each do
        get '/api/v1/items'
        parsed = JSON.parse(response.body, symbolize_names: true)
        @items = parsed[:data]
      end
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
    end

    describe 'optional query params' do
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

    describe 'post' do
      it 'can can create a new item' do
        merchant = Merchant.first
        post "/api/v1/items", params: {name: "item1", description: "item1 description", unit_price: 10.99, merchant_id: merchant.id}
        parsed = JSON.parse(response.body, symbolize_names: true)
        new_item = parsed[:data]

        expect(new_item[:attributes][:name]).to eq("item1")
        expect(new_item[:attributes][:description]).to eq("item1 description")
        expect(new_item[:attributes][:unit_price]).to eq("10.99")
        expect(new_item[:attributes][:merchant_id]).to eq(merchant.id)
      end
    end

    describe 'patch' do
      it 'can update an existing item' do
        merchant = Merchant.first
        item = merchant.items.first
        put "/api/v1/items/#{item.id}", params: {name: "item1", description: "item1 description", unit_price: 10.99}
        parsed = JSON.parse(response.body, symbolize_names: true)
        updated_item = parsed[:data]

        expect(updated_item[:attributes][:name]).to eq("item1")
        expect(updated_item[:attributes][:description]).to eq("item1 description")
        expect(updated_item[:attributes][:unit_price]).to eq("10.99")
        expect(updated_item[:attributes][:merchant_id]).to eq(merchant.id)
      end
    end
    
    describe 'destroy' do
      it 'can delete an existing item' do
        merchant = Merchant.first
        item = merchant.items.last
        delete "/api/v1/items/#{item.id}"

        expect(response.status).to eq(204)
        expect(response.body).to eq("")
      end
    end
  end
end