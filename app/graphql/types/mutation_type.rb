module Types
  class MutationType < Types::BaseObject
    field :create_drink, mutation: Mutations::CreateDrink
    field :delete_drink, mutation: Mutations::DeleteDrink
  end
end
