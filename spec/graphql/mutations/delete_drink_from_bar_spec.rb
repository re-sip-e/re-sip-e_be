require 'rails_helper'

RSpec.describe Mutations::DeleteDrink, type: :request do
  describe 'happy path' do
    it 'can delete a drink provided drink id' do
      drink1 = create(:drink)
      ingredients = create_list(:ingredient, 3, drink: drink1)

      query_delete_drink = <<~GQL
        mutation{
          deleteDrink(input: {
             id: "#{drink1.id}"
           }
        )
        GQL


      expected = {
                    "data": {
                    }
                  }

      post '/graphql', params: {query: query_delete_drink}
      result = JSON.parse(response.body)

      expect(response).to be_successful
      expect(result).to eq(expected)
      expect(Drink.find(drink1.id)).to eq nil

    end

  end
end
