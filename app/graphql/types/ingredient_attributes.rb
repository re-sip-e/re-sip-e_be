class Types::IngredientAttributes < Types::BaseInputObject
  argument :name, String, required: false
  argument :quantity, String, required: false
end