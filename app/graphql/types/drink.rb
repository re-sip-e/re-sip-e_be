module Types
  class Drink < Types::BaseObject
    field :id, ID, null: true
    field :name, String
    field :img_url, String
    field :steps, String
    field :bar, Types::BarType
    field :ingredients, [Types::Ingredient], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end