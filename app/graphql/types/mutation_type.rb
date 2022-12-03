module Types
  class MutationType < Types::BaseObject
    field :create_drink, mutation: Mutations::CreateDrink
    field :create_ingredient, mutation: Mutations::CreateIngredient
  end
end
