module Types
  class MutationType < Types::BaseObject
    field :drink_update, mutation: Mutations::DrinkUpdate
    field :drink_create, mutation: Mutations::DrinkCreate
    field :delete_drink, mutation: Mutations::DeleteDrink
  end
end
