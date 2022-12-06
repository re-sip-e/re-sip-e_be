# frozen_string_literal: true

module Mutations
  class UpdateDrink < BaseMutation
    description "Updates a drink by id"

    argument :id, ID, required: true
    argument :ingredients, [Types::IngredientInputType], required: true
    argument :name, String, required: true
    argument :steps, String, required: true
    argument :img_url, String, required: true
  
    field :drink, Types::DrinkType
    field :errors, [String]

    def resolve(id:, ingredients:, name:, steps:, img_url:)
      drink = Drink.find(id)
      drink.ingredients.destroy_all

      ingredients.map! do |ingredient|
        Ingredient.new(ingredient.to_h)
      end

      if drink.update(name: name, steps: steps, img_url: img_url, ingredients: ingredients)
        {
          drink: drink,
          errors: []
        }
      else
        {
          drink: nil,
          errors: drink.errors.full_messages
        }
      end
    end
  end
end
