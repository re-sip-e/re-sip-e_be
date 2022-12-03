class Mutations::CreateDrink < Mutations::BaseMutation

  # argument :ingredients, [ID], loads: Types::IngredientType, required: true
  # argument :ingredients, [Mutations::CreateIngredient], required: true

# Working mutation with below code:
#   mutation{
#   createDrink(input: {
#     name: "Vodka Cranberry",
#     steps: "Mix together", 
#     imgUrl:"pretty picture",
#     barId: 1, 
#     ingredients:
#     [
#       {name: "Vodka",
#       quantity: "2 oz"},
#       {name: "Cranberry Juice",
#       quantity: "2 oz"}
#   ]}) {
#     id
#   }
# }

  argument :ingredients, [Types::IngredientAttributes]
  argument :name, String, required: true
  argument :steps, String, required: true
  argument :img_url, String, required: true
  argument :bar_id, ID, required: true

  type Types::DrinkType
  # field :drink, Types::DrinkType, null: false
  # field :errors, [String], null: false

  def resolve(ingredients:, name:, steps:, img_url:, bar_id:)
    binding.pry
    drink_ingredients = ingredients.map do |ingredient|
      binding.pry
      Ingredient.new(ingredient.to_h)
      ## Code working to this point as of Friday Night
    end
    
    new_drink = Drink.new(
      name: name,
      steps: steps,
      img_url: img_url,
      ingredients: drink_ingredients
    )

    if new_drink.save
      {
        drink: new_drink,
        errors: []
      }
    else
      {
        drink: nil,
        errors: new_drink.errors.full_messages
      }
    end

  end

  # def before_create(_record)
    
  # end
end