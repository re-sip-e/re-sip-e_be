module Types
  class MutationType < Types::BaseObject
    field :update_drink, mutation: Mutations::UpdateDrink
    field :create_drink, mutation: Mutations::CreateDrink
  end
end
