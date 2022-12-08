require 'rails_helper'

RSpec.describe 'adding a drink to a bar', type: :request do
  describe 'happy path' do
    it 'can add a drink with ingredients to a bar' do

      @bar = create(:bar)

      def create_drink_mutation
        <<~GQL
          mutation {
            createDrink(input:{
              name:"Negroni"
              imgUrl:"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg"
              steps:"Stir into glass over ice, garnish and serve."
              barId: "#{@bar.id}"
              ingredients:[
                {
                  description:"1 oz Gin"
                }
                {
                  description:"1 oz Campari"
                }
                {
                  description:"1 oz Sweet Vermouth"
                }
              ]
            }){
              drink{
                id
                name
                steps
                imgUrl
                createdAt
                updatedAt
                ingredients{
                  description
                  id
                }
              }
              errors
            }
          }
        GQL
      end

      post '/graphql', params: {query: create_drink_mutation}

      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)
      created_drink = Drink.last
# require "pry"; binding.pry
      expect(created_drink.bar).to eq(@bar)

      expect(created_drink.name).to eq("Negroni")
      expect(created_drink.img_url).to eq("https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg")
      expect(created_drink.steps).to eq("Stir into glass over ice, garnish and serve.")
      expect(created_drink.name).to eq("Negroni")

      expect(created_drink.ingredients[0].description).to eq("1 oz Gin")

      expect(created_drink.ingredients[1].description).to eq("1 oz Campari")

      expect(created_drink.ingredients[2].description).to eq("1 oz Sweet Vermouth")

      expected_result = {
        data: {
          createDrink: {
            drink: {
              id: created_drink.id.to_s,
              name: created_drink.name,
              steps: created_drink.steps,
              imgUrl: created_drink.img_url,
              createdAt: created_drink.created_at.iso8601,
              updatedAt: created_drink.updated_at.iso8601,
              ingredients: [
                {
                  id: created_drink.ingredients[0].id.to_s,
                  description: created_drink.ingredients[0].description
                },
                {
                  id: created_drink.ingredients[1].id.to_s,
                  description: created_drink.ingredients[1].description
                },
                {
                  id: created_drink.ingredients[2].id.to_s,
                  description: created_drink.ingredients[2].description
                }
              ]
            },
            errors: []
          }
        }
      }

      expect(result).to eq(expected_result)
    end
  end
end
