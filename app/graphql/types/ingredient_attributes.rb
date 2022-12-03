class Types::IngredientAttributes < Types::BaseInputObject
    argument :name, String, required: true
    argument :quantity, String, required: true
end
