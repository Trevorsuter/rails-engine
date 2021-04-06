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
        expect(merchant).to have_key(:id)
        expect(merchant[:attributes]).to have_key(:name)
      end
    end

    it 'defaults to 20 merchants per page' do

      expect(@merchants.length).to eq(20)
    end

    it 'can set the per page limit' do
      get '/api/v1/merchants?per_page=40'
      forty_parsed = JSON.parse(response.body, symbolize_names: true)
      forty_merchants = forty_parsed[:data]
      
      expect(forty_merchants.length).to eq(40)
    end

    it 'can set a designated page' do
      get '/api/v1/merchants?page=2'
      paginated_parsed = JSON.parse(response.body, symbolize_names: true)
      paginated_merchants = paginated_parsed[:data]
      last_merchant = Merchant.offset(19).first
      start_merchant = Merchant.offset(20).first

      expect(paginated_merchants.first[:id].to_i).to eq(start_merchant.id)
      expect(paginated_merchants.first[:id].to_i).to_not eq(last_merchant.id)
    end

    it 'still sets to a default per page limit of 20 when page is assigned' do
      get '/api/v1/merchants?page=2'
      paginated_parsed = JSON.parse(response.body, symbolize_names: true)
      paginated_merchants = paginated_parsed[:data]

      expect(paginated_merchants.length).to eq(20)
    end

    it 'can set per page and page parameters' do
      get '/api/v1/merchants?page=2&per_page=10'
      triple_p_parsed = JSON.parse(response.body, symbolize_names: true)
      triple_p_merchants = triple_p_parsed[:data]
      last_merchant = Merchant.offset(9).first
      first_merchant = Merchant.offset(10).first

      expect(triple_p_merchants.first[:id].to_i).to eq(first_merchant.id)
      expect(triple_p_merchants.first[:id].to_i).to_not eq(last_merchant.id)

      expect(triple_p_merchants.length).to eq(10)
    end
  end
end