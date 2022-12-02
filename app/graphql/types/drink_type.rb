# frozen_string_literal: true

module Types
  class DrinkType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :img_url, String
    field :steps, String
    field :ingredients, [Types::IngredientType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
