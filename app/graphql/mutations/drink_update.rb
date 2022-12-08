# frozen_string_literal: true

module Mutations
  class DrinkUpdate < BaseMutation
    description "Updates a drink by id"

    field :drink, Types::DrinkType, null: false

    argument :id, ID, required: true
    argument :drink_input, Types::DrinkInputType, required: true

    def resolve(id:, drink_input:)
      drink = ::Drink.find(id)
      raise GraphQL::ExecutionError.new "Error updating drink", extensions: drink.errors.to_hash unless drink.update(**drink_input)

      { drink: drink }
    end
  end
end
