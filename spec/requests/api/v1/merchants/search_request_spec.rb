require 'rails_helper'

RSpec.describe 'merchant search API' do
  before :each do
    @upper_turing = create(:merchant, name: "Turing School")
    @upper_ring_world = create(:merchant, name: "Ring World")
    @lower_turing = create(:merchant, name: "turing school")
    @lower_ring_world = create(:merchant, name: "ring world")
    @jack_hammer = create(:merchant, name: "Jack Hammer")
    @co_lift = create(:merchant, name: "Colorado Lift")
    @scileppis = create(:merchant, name: "Scileppi's")
    @sliceworks = create(:merchant, name: "Sliceworks")
    @homebot = create(:merchant, name: "HomeBot")
  end

  describe 'find_all' do
    describe 'happy path' do
      before :each do
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

        expect(names).to include(@upper_turing.name)
        expect(names).to include(@lower_turing.name)
        expect(names).to include(@upper_ring_world.name)
        expect(names).to include(@lower_ring_world.name)
      end

      it 'will order each record by name ascending and case sensitive' do
        expected = [@upper_ring_world.name, 
                    @upper_turing.name, 
                    @lower_ring_world.name, 
                    @lower_turing.name]

        names = @results.map do |result|
          result[:attributes][:name]
        end

        expect(names).to eq(expected)
      end
    end

    describe 'sad path' do

      it 'should return a 400 status if no value is given' do
        get '/api/v1/merchants/find_all', params: {name: ""}

        expect(response.status).to eq(400)
      end

      it 'should return a 400 status if no param is given' do
        get '/api/v1/merchants/find_all'

        expect(response.status).to eq(400)
      end
    end
  end 
end