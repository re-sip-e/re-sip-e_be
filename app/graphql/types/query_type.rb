module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :drinks, [Types::Drink], null: false do
      argument :bar_id, ID, required: true
    end

    def drinks(bar_id:)
      bar = Bar.find(bar_id)
      bar.drinks
    end
  end
end
