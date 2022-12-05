module Types
  class MutationType < Types::BaseObject
    field :drink_update, mutation: Mutations::DrinkUpdate
    field :create_drink, mutation: Mutations::CreateDrink
  end
end
