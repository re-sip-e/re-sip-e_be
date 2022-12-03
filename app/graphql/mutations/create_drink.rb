class Mutations::CreateDrink < Mutations::BaseMutation

##Example mutation to run: 
# mutation{
#   createDrink(input: {
#     name: "Vodka Cranberry",
#     steps: "Mix together", 
#     imgUrl:"pretty picture",
#     barId: 1
#   } ) {
#     id
#   }
# }

 ## With the below two lines commented out I can run a mutation and get to the first pry in our resolver however this does not provide us teh info needed for ingredients. The below 2 lines are 2 different thoughts on how to get teh array of ingredients that need to be created for the drink (the first does not cause an GQL error but would require us to create an ingredient before the drink, the second line is non-working code.)

 
  # argument :ingredients, [ID], loads: Types::IngredientType, required: true
  # argument :ingredients, [Mutations::CreateIngredient], required: true
  argument :name, String, required: true
  argument :steps, String, required: true
  argument :img_url, String, required: true
  argument :bar_id, ID, required: true

  type Types::DrinkType
  # field :drink, Types::DrinkType, null: false
  # field :errors, [String], null: false

  def resolve(name:, steps:, img_url:, bar_id:)
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

  # def before_create(_record)
    
  # end
end