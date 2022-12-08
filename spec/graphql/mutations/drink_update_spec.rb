require 'rails_helper'

RSpec.describe Mutations::DrinkUpdate, type: :request do

  describe 'happy path' do
    it 'updates a drink' do
      drink = create(:drink)
      ingredients = create_list(:ingredient, 3, drink: drink)

      updated_drink_json = <<~JSON
        {
          "name": "Modified #{drink.name}",
          "steps": "#{drink.steps}",
          "imgUrl": "#{drink.img_url}",
          "ingredients": [
            {
              "id": "#{ingredients[0].id}",
              "description": "#{ingredients[0].description}",
              "_destroy": true
            },
            {
              "id": "#{ingredients[1].id}",
              "description": "#{ingredients[1].description}",
              "_destroy": true
            },
            {
              "id": "#{ingredients[2].id}",
              "description": "#{ingredients[2].description}"
            },
            {
              "id": null,
              "description": "New Description"
            }
          ]
        }
      JSON

      gql_vars = <<~JSON
        {
          "input":{
            "id": "#{drink.id}",
            "drinkInput": #{updated_drink_json}
          }
        }
      JSON

      mutation = <<~GQL
        mutation($input: DrinkUpdateInput!){
          drinkUpdate(input: $input){
            drink{
              id
              name
              steps
              imgUrl
              ingredients{
                id
                description
              }
            }
          }
        }
      GQL


      post '/graphql', params: {query: mutation, variables: gql_vars}
      result = JSON.parse(response.body, symbolize_names: true)

      updated_drink = Drink.find(drink.id)
      expected = {
        data: {
          drinkUpdate: {
            drink: {
              id: drink.id.to_s,
              name: "Modified #{drink.name}",
              steps: drink.steps,
              imgUrl: drink.img_url,
              ingredients: [
                {
                  id: ingredients[2].id.to_s,
                  description: ingredients[2].description
                },
                {
                  id: updated_drink.ingredients.last.id.to_s,
                  description: "New Description"
                }
              ]
            }
          }
        }
      }

  # require "pry"; binding.pry
      expect(response).to be_successful
      expect(result).to eq(expected)

      expect(updated_drink.name).to_not eq(drink.name)
      expect(updated_drink.name).to eq("Modified #{drink.name}")

      expect(updated_drink.img_url).to eq(drink.img_url)

      expect(updated_drink.steps).to eq(drink.steps)

      expect(updated_drink.ingredients.length).to eq(2)

      expect(updated_drink.ingredients[0].id).to eq(ingredients[2].id)
      expect(updated_drink.ingredients[0].description).to eq(ingredients[2].description)

      expect(updated_drink.ingredients[1].description).to eq("New Description")
    end
  end
end
