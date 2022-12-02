class Mutations::CreateDrink < Mutations::BaseMutation
  argument :ingredients, [Types::IngredientType], required: true
  argument :name, String, required: true
  argument :steps, String, required: true
  argument :img_url, String, required: true

  field :drink, Types::DrinkType, null: false
  field :errors, [String], null: false

  def resolve(ingredients:, name:, steps:, img_url:)
    binding.pry
    drink_ingredients = ingredients.map do |ingredient|
      binding.pry
      Ingredient.new()
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

  def before_create(_record)
    
  end
end