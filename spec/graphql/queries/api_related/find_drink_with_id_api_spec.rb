require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do

  describe 'happy path' do
    it 'can find a drink by id from api', :vcr do

      def query_drink
        <<~GQL
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
      end

      expected = {
        "data"=> {
          "apiDrink"=> {
            "id"=> "11003",
            "name"=> "Negroni",
            "steps"=> "Stir into glass over ice, garnish and serve.",
            "imgUrl"=> "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
            "ingredients"=> [
              {
                "name"=> "Gin",
                "quantity"=> "1 oz ",
              },
              {
                "name"=> "Campari",
                "quantity"=> "1 oz "
              },
              {
                "name"=> "Sweet Vermouth",
                "quantity"=> "1 oz "
              }
            ]
          }
        }
      }

      post '/graphql', params: {query: query_drink}
      result = JSON.parse(response.body)
      expect(response).to be_successful
      expect(result).to eq(expected)

    end
  end


end
