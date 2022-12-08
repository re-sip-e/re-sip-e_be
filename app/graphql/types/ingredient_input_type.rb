# frozen_string_literal: true

module Types
  class IngredientInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :name, String, required: false
    argument :drink_id, Integer, required: false
    argument :quantity, String, required: false
    argument :_destroy, Boolean, required: false
    argument :created_at, GraphQL::Types::ISO8601DateTime, required: false
    argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
  end
end
