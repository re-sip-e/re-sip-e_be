class AddBarToDrinks < ActiveRecord::Migration[5.2]
  def change
    add_reference :drinks, :bar, foreign_key: true
  end
end
