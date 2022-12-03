# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

bar = Bar.create!(name: "Joes Bar")
drink = Drink.create!(name: "Vodka Soda", img_url: "picture here", steps: "mix the stuff", bar: bar)
ingredient_1 = Ingredient.create!(name: "Vodka", quantity: "1 oz", drink: drink)
ingredient_2 = Ingredient.create!(name: "Soda", quantity: "1 oz", drink: drink)
