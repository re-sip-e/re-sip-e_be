class CreateDrinks < ActiveRecord::Migration[5.2]
  def change
    create_table :drinks do |t|
      t.string :name
      t.string :img_url
      t.references :bar, foreign_key: true
      t.string :steps

      t.timestamps
    end
  end
end
