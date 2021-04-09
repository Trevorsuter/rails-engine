require 'rails_helper'

RSpec.describe 'Merchant total revenue API' do
  before :each do
    @merchant = create(:merchant)
    @customer = create(:customer)
    @item = create(:item, merchant: @merchant, unit_price: 10)
    @invoices = create_list(:invoice, 10, merchant: @merchant, customer: @customer, status: 'shipped' )
    @invoices.each do |invoice|
      create(:invoice_item, invoice: invoice, item: @item)
      create(:transaction, invoice: invoice, result: 'success')
    end
  end

  describe 'happy path' do
    before :each do
      get "/api/v1/revenue/merchants/#{@merchant.id}"
      parsed = JSON.parse(response.body, symbolize_names: true)
      @result = parsed[:data]
    end

    it 'should have a successful response' do

      expect(response.status).to eq(200)
    end

    it 'should return the correct merchant' do

      expect(@result[:id].to_i).to eq(@merchant.id)
    end

    it 'should return the total revenue for the merchant' do

      expect(@result[:attributes][:revenue].to_i).to eq(@merchant.revenue.to_i)
    end
  end

  describe 'sad path' do

    it 'sends a 400 status if sent a bad merchant id' do
      get '/api/v1/revenue/merchants/0'

      expect(response.status).to eq(404)
    end
  end
end