require 'rails_helper'

RSpec.describe Mutations::DrinkCreate, type: :request do
  describe 'happy path' do
    it 'can add a drink with ingredients to a bar' do

      bar = create(:bar)

      drink_json = <<~JSON
        {
          "name": "Negroni",
          "steps": "Stir into glass over ice, garnish and serve.",
          "imgUrl": "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
          "barId": #{bar.id},
          "ingredients": [
            {
              "name": "Gin",
              "quantity": "1 oz"
            },
            {
              "name": "Campari",
              "quantity": "1.5 oz"
            },
            {
              "name": "Sweet Vermouth",
              "quantity": "1 oz"
            }
          ]
        }
      JSON

      gql_vars = <<~JSON
        {
          "input":{
            "drinkInput": #{drink_json}
          }
        }
      JSON

      mutation = <<~GQL
        mutation($input: DrinkUpdateInput!){
          drinkCreate(inpute: $input){
            drink{
              id
              name
              ingredients{
                id
                name
              }
            }
          }
        }
      GQL

      post '/graphql', params: {query: create_drink_mutation, variables: gql_vars}

      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)
      created_drink = Drink.last

      expect(created_drink.bar).to eq(@bar)

      expect(created_drink.name).to eq("Negroni")
      expect(created_drink.img_url).to eq("https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg")
      expect(created_drink.steps).to eq("Stir into glass over ice, garnish and serve.")
      expect(created_drink.name).to eq("Negroni")

      expect(created_drink.ingredients[0].name).to eq("Gin")
      expect(created_drink.ingredients[0].quantity).to eq("1 oz")

      expect(created_drink.ingredients[1].name).to eq("Campari")
      expect(created_drink.ingredients[1].quantity).to eq("1 oz")

      expect(created_drink.ingredients[2].name).to eq("Sweet Vermouth")
      expect(created_drink.ingredients[2].quantity).to eq("1 oz")

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
                  name: created_drink.ingredients[0].name,
                  quantity: created_drink.ingredients[0].quantity
                },
                {
                  id: created_drink.ingredients[1].id.to_s,
                  name: created_drink.ingredients[1].name,
                  quantity: created_drink.ingredients[1].quantity
                },
                {
                  id: created_drink.ingredients[2].id.to_s,
                  name: created_drink.ingredients[2].name,
                  quantity: created_drink.ingredients[2].quantity
                }
              ]
            }
          }
        }
      }

      expect(result).to eq(expected_result)
    end
  end
end
