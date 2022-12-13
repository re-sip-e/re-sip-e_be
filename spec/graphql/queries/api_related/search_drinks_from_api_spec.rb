require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do
  describe 'happy path' do
    it 'can find drinks by name from api', :vcr do
      query_drinks = <<~GQL
        query {
          apiDrinks(query: "negroni") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      expected = { 'data' => {
        'apiDrinks' => [{
          'id' => '11003',
          'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg',
          'ingredients' => [{
            'description' => '1 oz  Gin'
          }, {
            'description' => '1 oz  Campari'
          }, {
            'description' => '1 oz  Sweet Vermouth'
          }],
          'name' => 'Negroni',
          'steps' => 'Stir into glass over ice, garnish and serve.'
        }, {
          'id' => '17248',
          'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/x8lhp41513703167.jpg',
          'ingredients' => [{
            'description' => '1 oz Gin'
          }, {
            'description' => '1 oz Lillet'
          }, {
            'description' => '1 oz Sweet Vermouth'
          }, {
            'description' => '1 Orange Peel'
          }],
          'name' => 'French Negroni',
          'steps' => "Add ice to a shaker and pour in all ingredients.\nUsing a bar spoon, stir 40 to 45 revolutions or until thoroughly chilled.\nStrain into a martini glass or over ice into a rocks glass. Garnish with orange twist."
        }, {
          'id' => '178340',
          'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/kb4bjg1604179771.jpg',
          'ingredients' => [{
            'description' => '30 ml Gin'
          }, {
            'description' => '30 ml Campari'
          }, {
            'description' => '90 ml Orange Juice'
          }, {
            'description' => 'Garnish with Orange Peel'
          }],
          'name' => 'Garibaldi Negroni',
          'steps' => 'Mix together in a shaker and garnish with a simple orange slice. Fill your vitamin C and cocktail fix at the same time!'
        }]
      } }

      post '/graphql', params: { query: query_drinks }
      result = JSON.parse(response.body)
      expect(response).to be_successful
      expect(result).to eq(expected)
    end
  end

  describe 'Edge Case' do
    it 'If a search is done that provides no results an error message is recieved', :vcr do

      query_drinks_api_no_response = <<~GQL
        query {
          apiDrinks(query: "potato") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      post '/graphql', params: { query: query_drinks_api_no_response }
      result = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(result[:errors][0][:message]).to eq("Couldn't find Cocktail with 'name'=potato")
    end


    it 'If Cocktail DB API is not responsive an Error is returned in GraphQL' do
      stub_request(:get, 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=negroni').to_return(status: 500)

      query_drinks_api_down = <<~GQL
        query {
          apiDrinks(query: "negroni") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      post '/graphql', params: { query: query_drinks_api_down }
      result = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(result[:errors][0][:message]).to eq('the server responded with status 500')
    end

    it 'If an Invalid request is sent to the Cocktail DB API a server Error is returned in GraphQL' do
      stub_request(:get, 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=negroni').to_return(status: 400)

      query_drinks_api_down = <<~GQL
        query {
          apiDrinks(query: "negroni") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      post '/graphql', params: { query: query_drinks_api_down }
      result = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(result[:errors][0][:message]).to eq('the server responded with status 400')
    end
  end
end
