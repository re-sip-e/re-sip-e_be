# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name: "Joe Schmoe", email: "joe.schmoe@gmail.com", location: "New York, NY")

bar = Bar.create!(name: "Joe's Bar")
bar.users << user

drink_1 = Drink.create!(name: "Negroni", img_url: "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg", steps: "Stir into glass over ice, garnish and serve.", bar: bar)

ingredient_1 = Ingredient.create!(name: "Gin", quantity: "1 oz", drink: drink_1)
ingredient_2 = Ingredient.create!(name: "Campari", quantity: "1 oz", drink: drink_1)
ingredient_3 = Ingredient.create!(name: "Sweet Vermouth", quantity: "1 oz", drink: drink_1)

drink_2 = Drink.create!(name: "Aviation", img_url: "https://www.thecocktaildb.com/images/media/drink/trbplb1606855233.jpg", steps: "Add all ingredients into cocktail shaker filled with ice. Shake well and strain into cocktail glass. Garnish with a cherry.", bar: bar)

ingredient_4 = Ingredient.create!(name: "Gin", quantity: "4.5 cl", drink: drink_2)
ingredient_5 = Ingredient.create!(name: "Lemon Juice", quantity: "1.5 cl", drink: drink_2)
ingredient_6 = Ingredient.create!(name: "Maraschino Liqueur", quantity: "1.5 cl", drink: drink_2)

