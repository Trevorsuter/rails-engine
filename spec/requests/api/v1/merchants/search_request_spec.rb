require 'rails_helper'

RSpec.describe 'merchant search API' do

  describe 'find_one' do
  end

  describe 'find_all' do
    describe 'happy path' do
      before :each do
        create(:merchant, name: "Turing School")
        create(:merchant, name: "Ring World")
        create(:merchant, name: "turing school")
        create(:merchant, name: "ring world")
        create(:merchant, name: "Jack Hammer")
        create(:merchant, name: "Colorado Lift")
        create(:merchant, name: "Scileppi's")
        create(:merchant, name: "Sliceworks")
        create(:merchant, name: "HomeBot")

        get '/api/v1/merchants/find_all', params: { name: "ring" }
        parsed = JSON.parse(response.body, symbolize_names: true)
        @results = parsed[:data]
      end

      it 'returns a successful response' do

        expect(response).to be_successful
      end

      it 'will fetch the correct records' do
        names = @results.map do |result|
          result[:attributes][:name]
        end

        expect(names).to include("Turing School")
        expect(names).to include("turing school")
        expect(names).to include("Ring World")
        expect(names).to include("ring world")
      end
    end
  end 
end