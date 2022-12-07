# frozen_string_literal: true

module Types
  class DrinkInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :name, String, required: false
    argument :img_url, String, required: false
    argument :bar_id, Integer, required: false
    argument :steps, String, required: false
    argument :ingredients, [IngredientInputType], required: false, as: :ingredients_attributes
    argument :created_at, GraphQL::Types::ISO8601DateTime, required: false
    argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
  end
end
