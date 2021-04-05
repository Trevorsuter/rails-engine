require 'rails_helper'

RSpec.describe 'merchant request spec' do
  before :each do
    create_list(:merchant, 3)

    get "/api/v1/merchants/#{Merchant.first.id}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    @merchant = parsed[:data]
    @attributes = @merchant[:attributes]
  end

  describe 'happy path' do
    it 'has a successful response' do

      expect(response).to be_successful
    end

    it 'has the correct data' do

      expect(@attributes).to have_key(:id)
      expect(@attributes).to have_key(:name)
    end
  end

  describe 'sad path' do
    it 'does not find the wrong merchant' do

      expect(@attributes[:id]).to_not eq(Merchant.second.id)
      expect(@attributes[:id]).to_not eq(Merchant.last.id)
    end
  end
end