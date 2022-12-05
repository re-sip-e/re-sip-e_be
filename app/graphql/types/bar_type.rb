# frozen_string_literal: true

module Types
  class BarType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :drinks, [Types::DrinkType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :drink_count, Integer

    def drink_count
      bar = Bar.find(object.id)
      bar.drinks.count
    end
  end
end
