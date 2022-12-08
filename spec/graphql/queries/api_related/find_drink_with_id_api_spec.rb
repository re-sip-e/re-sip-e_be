require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do
  describe 'Find a Drink from Cocktail API' do
    describe 'happy path' do
      it 'can find a drink by id from api', :vcr do
        query_drink = <<~GQL
          query {
            apiDrink(id: 11003){
              id
              name
              steps
              imgUrl
              ingredients {
                name
                quantity
              }
            }
          }
        GQL

        expected = {
          'data' => {
            'apiDrink' => {
              'id' => '11003',
              'name' => 'Negroni',
              'steps' => 'Stir into glass over ice, garnish and serve.',
              'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg',
              'ingredients' => [
                {
                  'name' => 'Gin',
                  'quantity' => '1 oz '
                },
                {
                  'name' => 'Campari',
                  'quantity' => '1 oz '
                },
                {
                  'name' => 'Sweet Vermouth',
                  'quantity' => '1 oz '
                }
              ]
            }
          }
        }

        post '/graphql', params: { query: query_drink }
        result = JSON.parse(response.body)
        expect(response).to be_successful
        expect(result).to eq(expected)
      end
    end

    describe 'Sad Paths' do
      it 'If an Invalid Drink ID for teh API is received an Error is returned', :vcr do
        query_invalid_drink = <<~GQL
          query {
            apiDrink(id: 1){
              id
              name
              steps
              imgUrl
              ingredients {
                name
                quantity
              }
            }
          }
        GQL
        
        post '/graphql', params: { query: query_invalid_drink }
        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(result[:errors][0][:message]).to eq("Drink not found")
      end
    end

    describe 'Edge Cases' do
      it 'Fields are requested multiple times in query a a valid response is returned', :vcr do
        query_duplicate_drink = <<~GQL
          query {
            apiDrink(id: 11003){
              id
              id
              name
              name
              steps
              steps
              imgUrl
              imgUrl
              ingredients {
                name
                name
                quantity
                quantity
              }
            }
          }
        GQL
        
        expected = {
          'data' => {
            'apiDrink' => {
              'id' => '11003',
              'name' => 'Negroni',
              'steps' => 'Stir into glass over ice, garnish and serve.',
              'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg',
              'ingredients' => [
                {
                  'name' => 'Gin',
                  'quantity' => '1 oz '
                },
                {
                  'name' => 'Campari',
                  'quantity' => '1 oz '
                },
                {
                  'name' => 'Sweet Vermouth',
                  'quantity' => '1 oz '
                }
              ]
            }
          }
        }

        post '/graphql', params: { query: query_duplicate_drink }
        result = JSON.parse(response.body)
        expect(response).to be_successful
        expect(result).to eq(expected)
      end
    end
  end
end
