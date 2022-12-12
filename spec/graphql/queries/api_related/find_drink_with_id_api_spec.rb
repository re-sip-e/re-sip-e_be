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
                description
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
                  'description' => '1 oz  Gin'
                },
                {
                  'description' => '1 oz  Campari'
                },
                {
                  'description' => '1 oz  Sweet Vermouth'
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
                description
              }
            }
          }
        GQL

        post '/graphql', params: { query: query_invalid_drink }
        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(result[:errors][0][:message]).to eq("Couldn't find Cocktail with 'id'=1")
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
                description
                description
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
                  'description' => '1 oz  Gin'
                },
                {
                  'description' => '1 oz  Campari'
                },
                {
                  'description' => '1 oz  Sweet Vermouth'
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

      it 'If Cocktail DB API is not responsive an Error is returned in GraphQL' do
        stub_request(:get, 'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11003').to_return(status: 500)

        query_api_down_drink = <<~GQL
          query {
            apiDrink(id: 11003){
              id
              name
              steps
              imgUrl
              ingredients {
                description
              }
            }
          }
        GQL

        post '/graphql', params: { query: query_api_down_drink }
        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(result[:errors][0][:message]).to eq('the server responded with status 500')
      end

      it 'If an Invalid request is sent to the Cocktail DB API a server Error is returned in GraphQL' do
        stub_request(:get, 'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11003').to_return(status: 400)

        query_api_down_drink = <<~GQL
          query {
            apiDrink(id: 11003){
              id
              name
              steps
              imgUrl
              ingredients {
                description
              }
            }
          }
        GQL

        post '/graphql', params: { query: query_api_down_drink }
        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(result[:errors][0][:message]).to eq('the server responded with status 400')
      end
    end
  end
end
