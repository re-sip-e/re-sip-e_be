class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.references :drink, foreign_key: true
      t.string :quantity

      t.timestamps
    end
  end
end
