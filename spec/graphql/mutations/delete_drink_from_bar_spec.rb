require 'rails_helper'

RSpec.describe Mutations::DeleteDrink, type: :request do
  describe 'happy path' do
    it 'can delete a drink provided drink id' do
      bar = create(:bar)
      bar.drinks.destroy_all
      drink1 = create(:drink, bar: bar)

      query_delete_drink = <<~GQL
        mutation{
          deleteDrink(input: {
             id: "#{drink1.id}"
           }
        ){
          success
          errors}}
      GQL

      expected = { data: { deleteDrink: { errors: [], success: true } } }

      post '/graphql', params: { query: query_delete_drink }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(result).to eq(expected)
      expect(Drink.all).to eq([])
      expect { Drink.find(drink1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'deletes all drink ingredients when deleting a drink ' do
      bar = create(:bar)
      bar.drinks.destroy_all
      drink1 = create(:drink, bar: bar)
      ingredients = drink1.ingredients

      query_delete_drink = <<~GQL
        mutation{
          deleteDrink(input: {
             id: "#{drink1.id}"
           }
        ){
          success
          errors}}
      GQL

      expected = { data: { deleteDrink: { errors: [], success: true } } }
      
      expect(Ingredient.all).to eq([ingredients[0], ingredients[1], ingredients[2]])

      post '/graphql', params: { query: query_delete_drink }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(result).to eq(expected)
      expect(Ingredient.all).to eq([])
      expect { Ingredient.find(ingredients[0].id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Ingredient.find(ingredients[2].id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'sad path' do
    it 'It does not delete any drinks if no drink Id is provided and a no drink found error is provided' do
      bar = create(:bar)
      bar.drinks.destroy_all
      drinks = create_list(:drink, 5,  bar: bar)

      query_invalid_delete_drink = <<~GQL
        mutation{
          deleteDrink(input: {
             id: " "
           }
        ){
          success
          errors}}
      GQL

      expected = { data: { deleteDrink: nil },
                   errors: [
                     { locations: [{ column: 3, line: 2 }],
                       message: "Couldn't find Drink with 'id'= ",
                       path: ['deleteDrink'] }
                   ] }

      post '/graphql', params: { query: query_invalid_delete_drink }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(result).to eq(expected)
      expect(Drink.all.count).to eq(5)
    end

    it 'It does not delete any drinks if an invalid drink id is provided and a no drink found error is provided' do\
      bar = create(:bar)
      bar.drinks.destroy_all
      drinks = create_list(:drink, 5, bar: bar)

      query_invalid_delete_drink = <<~GQL
        mutation{
          deleteDrink(input: {
             id: "#{drinks[4].id + 1} "
           }
        ){
          success
          errors}}
      GQL

      expected = { data: { deleteDrink: nil },
                   errors: [
                     { locations: [{ column: 3, line: 2 }],
                       message: "Couldn't find Drink with 'id'=#{drinks[4].id + 1} ",
                       path: ['deleteDrink'] }
                   ] }

      post '/graphql', params: { query: query_invalid_delete_drink }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(result).to eq(expected)
      expect(Drink.all.count).to eq(5)
    end
  end
end
