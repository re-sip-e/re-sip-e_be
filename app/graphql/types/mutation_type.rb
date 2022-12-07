module Types
  class MutationType < Types::BaseObject
    field :drink_update, mutation: Mutations::DrinkUpdate
    field :drink_create, mutation: Mutations::DrinkCreate
  end
end
