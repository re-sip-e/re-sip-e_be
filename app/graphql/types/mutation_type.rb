module Types
  class MutationType < Types::BaseObject
    field :create_drink, mutation: Mutations::CreateDrink
  end
end
