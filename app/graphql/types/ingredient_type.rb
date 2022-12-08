# frozen_string_literal: true

module Types
  class IngredientType < Types::BaseObject
    field :id, ID, null: false
    field :description, String
    field :drink_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
