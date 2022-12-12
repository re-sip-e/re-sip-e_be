# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Drink.destroy_all
BarUser.destroy_all
Bar.destroy_all
User.destroy_all

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

user = User.create!(name: "Joe Schmoe", email: "joe.schmoe@gmail.com", location: "New York, NY")

bar = Bar.create!(name: "Joe's Bar")
bar.users << user

drink_1 = Drink.create!(
  name: "Negroni",
  img_url: "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
  steps: "Stir into glass over ice, garnish and serve.",
  bar: bar,
  ingredients_attributes: [
    {
      description: "1 oz Gin"
    },
    {
      description: "1 oz Campari"
    },
    {
      description: "1 oz Sweet Vermouth"
    }
  ]
)

drink_2 = Drink.create!(
  name: "Aviation",
  img_url: "https://www.thecocktaildb.com/images/media/drink/trbplb1606855233.jpg",
  steps: "Add all ingredients into cocktail shaker filled with ice. Shake well and strain into cocktail glass. Garnish with a cherry.",
  bar: bar,
  ingredients_attributes: [
    {
      description: "4.5 cl Gin"
    },
    {
      description: "1.5 cl Lemon Juice"
    },
    {
      description: "1.5 cl Maraschino Liqueur"
    }
  ]
)

