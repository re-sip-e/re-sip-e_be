class Mutations::CreateDrink < Mutations::BaseMutation
  argument :ingredients, [Types::IngredientInputType], required: false
  argument :name, String, required: false
  argument :steps, String, required: false
  argument :img_url, String, required: false
  argument :bar_id, ID, required: false

  field :drink, Types::DrinkType
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
      {
        drink: nil,
        errors: new_drink.errors.full_messages
      }
    end
  end
end