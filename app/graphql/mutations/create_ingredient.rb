class Mutations::CreateIngredient < Mutations::BaseMutation
  argument :name, String, required: true
  argument :quantity, String, required: true

  type Types::IngredientType
  # field :errors, [String], null: false

  def resolve(name:, quantity:)
    ingredient.new(name: name, quantity: quantity)
  end
end