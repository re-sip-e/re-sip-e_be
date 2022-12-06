class Mutations::CreateDrink < Mutations::BaseMutation
  argument :ingredients, [Types::IngredientInputType], required: true
  argument :name, String, required: true
  argument :steps, String, required: true
  argument :img_url, String, required: true
  argument :bar_id, ID, required: true

  field :drink, Types::DrinkType
  field :errors, [String]

  def resolve(ingredients:, name:, steps:, img_url:, bar_id:)

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