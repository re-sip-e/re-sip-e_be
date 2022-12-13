module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :drinks, [Types::DrinkType], null: false do
      argument :bar_id, ID, required: true
    end

    def drinks(bar_id:)
      bar = Bar.find(bar_id)
      bar.drinks
    end

    field :drink, Types::DrinkType, null: false do
      argument :id, ID, required: true
    end

    def drink(id:)
      Drink.find(id)
    end

    field :api_drinks, [Types::DrinkType], null: false do
      argument :query, String, required: true
    end

    def api_drinks(query:)
      CocktailFacade.by_name(query)
    end

    field :api_drink, Types::DrinkType, null: true do
     argument :id, ID, required: true
    end

    def api_drink(id:)
      CocktailFacade.cocktail_by_id(id)
    end

    field :three_random_api_drinks, [Types::DrinkType], null: true

    def three_random_api_drinks
      CocktailFacade.three_random
    end

    field :bar, Types::BarType, null: false do
      argument :id, ID, required: true
    end

    def bar(id:)
      Bar.find(id)
    end

    field :user, Types::UserType, null:false do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end
  end
end
