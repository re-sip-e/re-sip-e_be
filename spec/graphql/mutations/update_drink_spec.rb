require 'rails_helper'

RSpec.describe Mutations::UpdateDrink, type: :request do
  
  describe 'happy path' do
    it 'updates a drink' do
      drink = create(:drink)
      ingredients = create_list(:ingredient, 3, drink: drink)

      update_drink_mutation = <<~GQL
        mutation {
          updateDrink(input:{
            id: "#{drink.id}"
            name: "Updated Name"
            imgUrl: "#{drink.img_url}"
            steps: "Updated Steps"
            ingredients: [
              {
                name: "#{ingredients[0].name}
                quantity: "#{ingredients[0].quantity}"
              }
              {
                name: "Campari"
                quantity: "1 oz"
              }
              {
                name: "Updated Ingredient Name"
                quantity: "#{ingredients[2].quantity}"
              }
            ]
          }){
            drink {
              id
              name
              imgUrl
              steps
              ingredients{
                name
                quantity
              }
            }
          }
        }
      GQL

      expected = {
        data: {
          updateDrink: {
            id: drink.id.to_s,
            name: "Updated Name",
            imgUrl: drink.img_url,
            steps: "Updated Steps",
            ingredients: [
              {
                name: ingredient[0].name,
                quantity: ingredient[0].quantity
              },
              {
                name: "Campari",
                quantity: "1 oz"
              },
              {
                name: "Updated Ingredient Name",
                quantity: ingredient[2].quantity
              }
            ]
          }
        }
      }

      post '/graphql', params: {query: update_drink_mutation}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(result).to eq(expected)

      updated_drink = Drink.find(drink.id)

      expect(updated_drink.name).to_not eq(drink.name)
      expect(updated_drink.name).to eq("Updated Name")

      expect(updated_drink.img_url).to eq(drink.img_url)

      expect(updated_drink.steps).to_not eq(drink.steps)
      expect(updated_drink.steps).to eq("Updated Steps")

      expect(updated_drink.ingredients[0]).to eq(ingredients[0])

      expect(updated_dirnk.ingredients[1]).to_not eq(ingredients[1])
      expect(updated_drink.ingredients[1].name).to eq("Campari")
      expect(updated_drink.ingredients[1].quantity).to eq("1 oz")
      
      expect(updated_drink.ingredients[2].name).to_not eq(ingredients[2].name)
      expect(updated_drink.ingredients[2].name).to eq("Updated Ingredient Name")
      expect(updated_drink.ingredients[2].quantity).to eq(ingredients[2].quantity)
    end
  end
end