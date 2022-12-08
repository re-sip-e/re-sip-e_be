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

ingredient_1 = Ingredient.create!(description: "1 oz Gin", drink: drink_1)
ingredient_2 = Ingredient.create!(description: "1 oz Campari", drink: drink_1)
ingredient_3 = Ingredient.create!(description: "1 oz Sweet Vermouth", drink: drink_1)

drink_2 = Drink.create!(name: "Aviation", img_url: "https://www.thecocktaildb.com/images/media/drink/trbplb1606855233.jpg", steps: "Add all ingredients into cocktail shaker filled with ice. Shake well and strain into cocktail glass. Garnish with a cherry.", bar: bar)

ingredient_4 = Ingredient.create!(description: "4.5 cl Gin", drink: drink_2)
ingredient_5 = Ingredient.create!(description: "1.5 cl Lemon Juice", drink: drink_2)
ingredient_6 = Ingredient.create!(description: "1.5 cl Maraschino Liqueur", drink: drink_2)

