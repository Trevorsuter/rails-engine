require 'rails_helper'

RSpec.describe 'Merchants API' do
  before :each do
    create_list(:merchant, 50)
    get '/api/v1/merchants'

    parsed = JSON.parse(response.body, symbolize_names: true)
    @merchants = parsed[:data]
  end

  describe 'happy path' do
    it 'has a successful response' do

      expect(response).to be_successful
    end

    it 'sends the correct data' do

      @merchants.each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:id)
        expect(merchant[:attributes][:id]).to be_an(Integer)
      end
    end

    it 'defaults to 20 merchants per page' do

      expect(@merchants.length).to eq(20)
    end
  end
end