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

  argument :ingredients, [Types::IngredientAttributes], required: false
  argument :name, String, required: false
  argument :steps, String, required: false
  argument :img_url, String, required: false
  argument :bar_id, ID, required: false

  # type Types::DrinkType
  field :drink, Types::Drink
  field :errors, [String]

  def resolve(ingredients:, name:nil, steps:, img_url:, bar_id:)

    ingredients.map! do |ingredient|
      Ingredient.new(ingredient.to_h)
    end
    
    new_drink = Drink.new(
      bar_id: bar_id,
      name: name,
      steps: steps,
      ingredients: ingredients,
      img_url: img_url
    )
    
    if new_drink.save
      {
        drink: new_drink,
        errors: []
      }
    else
      errors = new_drink.errors.full_messages
      ingredients.each do |ingredient|
        ingredient.errors.full_messages.each do |ingredient_error_message|
          errors << ingredient_error_message
        end
      end
      {
        drink: nil,
        errors: errors
      }
    end
  end

end