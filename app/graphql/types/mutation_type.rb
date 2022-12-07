module Types
  class MutationType < Types::BaseObject
    field :drink_create, mutation: Mutations::DrinkCreate
    field :update_drink, mutation: Mutations::UpdateDrink
  end
end
