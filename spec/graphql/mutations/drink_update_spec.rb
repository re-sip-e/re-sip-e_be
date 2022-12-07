require 'rails_helper'

RSpec.describe Mutations::UpdateDrink, type: :request do
  
  describe 'happy path' do
    it 'updates a drink' do
      drink = create(:drink)
      ingredients = create_list(:ingredient, 3, drink: drink)

      updated_drink_json = <<~JSON
        {
          "name": "Modified #{drink.name}",
          "steps": "#{drink.steps}",
          "imgUrl": "#{drink.image_url}",
          "ingredients": [
            {
              "id": "#{ingredients[0].id}"
              "name": "#{ingredients[0].name}",
              "quantity": "#{ingredients[0].quantity}",
              "_destroy": true
            },
            {
              "id": "#{ingredients[1].id}"
              "name": "#{ingredients[1].name}",
              "quantity": "#{ingredients[1].quantity}",
              "_destroy": true
            },
            {
              "id": "#{ingredients[2].id}"
              "name": "#{ingredients[2].name}",
              "quantity": "Modified Quantity"
            },
            {
              "id": null,
              "name": "New Ingredient",
              "quantity": "New Ingredient Quantity"
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
                name
                quantity
              }
            }
          }
        }
      GQL

      
      post '/graphql', params: {query: update_drink_mutation, variables: gql_vars}
      result = JSON.parse(response.body, symbolize_names: true)
      
      updated_drink = Drink.find(drink.id)

      expected = {
        data: {
          updateDrink: {
            drink: {
              id: drink.id.to_s,
              name: "Modified #{drink.name}",
              imgUrl: drink.img_url,
              steps: drink.steps,
              ingredients: [
                {
                  id: ingredients[2].id.to_s,
                  name: ingredients[2].name,
                  quantity: "Modified Quantity"
                },
                {
                  id: updated_drink.ingredients.last.id.to_s,
                  name: "New Ingredient",
                  quantity: "New Ingredient Quantity"
                }
              ]
            },
            errors: []
          }
        }
      }
      
      expect(response).to be_successful
      expect(result).to eq(expected)

      # updated_drink = Drink.find(drink.id)

      # expect(updated_drink.name).to_not eq(drink.name)
      # expect(updated_drink.name).to eq("Updated Name")

      # expect(updated_drink.img_url).to eq(drink.img_url)

      # expect(updated_drink.steps).to_not eq(drink.steps)
      # expect(updated_drink.steps).to eq("Updated Steps")

      # expect(updated_drink.ingredients[0].name).to eq(ingredients[0].name)
      # expect(updated_drink.ingredients[0].quantity).to eq(ingredients[0].quantity)

      # expect(updated_drink.ingredients[1]).to_not eq(ingredients[1])
      # expect(updated_drink.ingredients[1].name).to eq("Campari")
      # expect(updated_drink.ingredients[1].quantity).to eq("1 oz")

      # expect(updated_drink.ingredients[2].name).to_not eq(ingredients[2].name)
      # expect(updated_drink.ingredients[2].name).to eq("Updated Ingredient Name")
      # expect(updated_drink.ingredients[2].quantity).to eq(ingredients[2].quantity)
    end
  end
end