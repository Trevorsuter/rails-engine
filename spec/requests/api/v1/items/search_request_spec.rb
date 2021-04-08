require 'rails_helper'

RSpec.describe 'items search API' do
  before :each do
    @merchant = create(:merchant)
    @jack_hammer = @merchant.items.create(name: "Jack Hammer", description: "item1 description", unit_price: 1.00)
    @yarn = @merchant.items.create(name: "Yarn", description: "item2 description", unit_price: 10.00)
    @hungry_hippos = @merchant.items.create(name: "Hungry Hippos", description: "item3 description", unit_price: 20.00)
    @knife = @merchant.items.create(name: "Knife", description: "item4 description", unit_price: 30.00)
    @hockey_stick = @merchant.items.create(name: "Hockey Stick", description: "item5 description", unit_price: 30.00)
    @glasses = @merchant.items.create(name: "Glasses", description: "item6 description", unit_price: 40.00)
    @jungle_juice = @merchant.items.create(name: "Jungle Juice", description: "item7 description", unit_price: 40.50)
    @upper_computer_hardware = @merchant.items.create(name: "Computer Hardware", description: "item8 description", unit_price: 45.00)
    @lower_computer_hardware = @merchant.items.create(name: "computer hardware", description: "item9 description", unit_price: 47.50)
  end

  describe 'find_one' do
    describe 'by name' do
      describe 'happy path' do
        before :each do
          get '/api/v1/items/find', params: {name: "computer hardware"}
          parsed = JSON.parse(response.body, symbolize_names: true)
          @result = parsed[:data]
        end

        it 'should have a successful response' do

          expect(response).to be_successful
        end

        it 'should return only one record' do

          expect(@result.length).to_not be_an(Array)
        end

        it 'should return the correct record' do

          expect(@result[:id].to_i).to eq(@upper_computer_hardware.id)
        end
      end
      describe 'sad path' do

        it 'should return an error if names param is blank' do
          get '/api/v1/items/find?name='

          expect(response.status).to eq(400)
        end

        it 'should return a 400 response code if no param is given' do
          get '/api/v1/items/find'

          expect(response.status).to eq(400)
        end

        it 'should return nil if there are no matches' do
          get '/api/v1/items/find', params: { name: "NOMATCH" }

          expect(@result).to eq(nil)
        end
      end
    end
    describe 'by price' do
      describe 'minimum' do
        describe 'happy path' do
          before :each do
            get '/api/v1/items/find', params: { min_price: 45 }
            parsed = JSON.parse(response.body, symbolize_names: true)
            @min_result = parsed[:data]
          end

          it 'should have a successful response' do

            expect(response).to be_successful
          end
  
          it 'should return only one record' do
  
            expect(@min_result).to_not be_an(Array)
          end

          it 'should return the right record' do

            expect(@min_result[:id].to_i).to eq(@upper_computer_hardware.id)
          end

          it 'should return the record thats first in aplhabetical order (case sensitive)' do

            expect(@min_result[:id].to_i).to_not eq(@lower_computer_hardware.id)
          end
        end
        describe 'sad path' do

          it 'should return a 400 status code if min price is empty' do
            get '/api/v1/items/find?min_price='

            expect(response.status).to eq(400)
          end

          it 'should give a 400 status code if min price and name params are given' do
            get '/api/v1/items/find', params: { name: "yarn", min_price: 10 }

            expect(response.status).to eq(400)
          end
        end
      end
      describe 'maximum' do
        describe 'happy path' do
          before :each do
            get '/api/v1/items/find', params: { max_price: 5 }
            parsed = JSON.parse(response.body, symbolize_names: true)
            @max_result = parsed[:data]
          end

          it 'should have a successful response' do

            expect(response).to be_successful
          end
  
          it 'should return only one record' do
  
            expect(@max_result).to_not be_an(Array)
          end

          it 'should return the correct record' do

            expect(@max_result[:id].to_i).to eq(@jack_hammer.id)
          end
        end
        describe 'sad path' do
          it 'should return a 400 response code if value is less than 0' do
            get '/api/v1/items/find', params: { min_price: -15 }

            expect(response.status).to eq(400)
          end

          it 'should return a 400 response code param is blank' do
            get '/api/v1/items/find?max_price='

            expect(response.status).to eq(400)
          end

          it 'should return a 400 response code if name and max price are given' do
            get '/api/v1/items/find', params: { name: "yarn", max_price: 10 }

            expect(response.status).to eq(400)
          end
        end
      end
      describe 'minimum and maximum' do
        describe 'happy path' do
          before :each do
            get '/api/v1/items/find', params: { min_price: 42, max_price: 50}
            parsed = JSON.parse(response.body, symbolize_names: true)
            @min_and_max_result = parsed[:data]
          end

          it 'has a successful response' do

            expect(response).to be_successful
          end

          it 'returns only one item' do

            expect(@min_and_max_result).to_not be_an(Array)
          end

          it 'returns the correct item' do

            expect(@min_and_max_result[:id].to_i).to eq(@upper_computer_hardware.id)
          end

          it 'returns the first item in alphabetical order (case sensitive)' do

            expect(@min_and_max_result[:id].to_i).to_not eq(@lower_computer_hardware.id)
          end
        end
        describe 'sad path' do

          it 'returns a 400 response if no values are given' do
            get '/api/v1/items/find', params: { min_price: "", max_price: "" }

            expect(response.status).to eq(400)
          end 

          it 'returns a 400 response if name is given with min and max price' do
            get '/api/v1/items/find', params: { name: "yarn", min_price: 40, max_price: 45 }

            expect(response.status).to eq(400)
          end
        end
      end
    end
  end
end