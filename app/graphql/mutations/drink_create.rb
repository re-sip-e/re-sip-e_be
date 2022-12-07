# frozen_string_literal: true

module Mutations
  class DrinkCreate < BaseMutation
    description "Creates a new drink"

    field :drink, Types::DrinkType, null: false

    argument :drink_input, Types::DrinkInputType, required: true

    def resolve(drink_input:)
      drink = ::Drink.new(**drink_input)
      raise GraphQL::ExecutionError.new "Error creating drink", extensions: drink.errors.to_hash unless drink.save

      { drink: drink }
    end
  end
end
