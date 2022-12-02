module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :drinks, [Types::DrinkType], null: false do
      argument :drink_name, String, required: false
    end

    def drinks(drink_name:nil)
      if drink_name
        CocktailFacade.by_name(drink_name)
      else
        Drink.all
      end
    end

    field :drink, Types::DrinkType, null: false do
      argument :id, ID, required: true
    end

    def drink(id:)
      Drink.find(id)
    end

  end
end
