class Mutations::DeleteDrink < Mutations::BaseMutation
  argument :id, ID, required: true
  field :errors, [String]
  field :success, Boolean

  def resolve(id:)
    drink = Drink.find(id)
    if drink.destroy
      { success: true,
        errors: [] }
    else
      { success: false,
        errors: [drink.errors.full_messages] }
    end
  end
end
