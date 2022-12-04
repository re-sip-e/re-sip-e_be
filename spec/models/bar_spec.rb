require 'rails_helper'

RSpec.describe Bar, type: :model do
  it { should validate_presence_of :name }
  it { should have_many :bar_users }
  it { should have_many(:users).through(:bar_users) }
  it { should have_many :drinks }

  describe 'instance methods' do
    before :each do
      @user = User.create!(name: "Joe Schmoe", email: "joe.schmoe@gmail.com", location: "New York, NY")
      @bar = Bar.create!(name: "Joe's Bar")
      @bar.users << @user
      @drink_1 = Drink.create!(name: "Negroni", img_url: "https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg", steps: "Stir into glass over ice, garnish and serve.", bar: @bar)
      @ingredient_1 = Ingredient.create!(name: "Gin", quantity: "1 oz", drink: @drink_1)
      @ingredient_2 = Ingredient.create!(name: "Campari", quantity: "1 oz", drink: @drink_1)
      @ingredient_3 = Ingredient.create!(name: "Sweet Vermouth", quantity: "1 oz", drink: @drink_1)
      @drink_2 = Drink.create!(name: "Aviation", img_url: "https://www.thecocktaildb.com/images/media/drink/trbplb1606855233.jpg", steps: "Add all ingredients into cocktail shaker filled with ice. Shake well and strain into cocktail glass. Garnish with a cherry.", bar: @bar)
      @ingredient_4 = Ingredient.create!(name: "Gin", quantity: "4.5 cl", drink: @drink_2)
      @ingredient_5 = Ingredient.create!(name: "Lemon Juice", quantity: "1.5 cl", drink: @drink_2)
      @ingredient_6 = Ingredient.create!(name: "Maraschino Liqueur", quantity: "1.5 cl", drink: @drink_2)
    end

    it '.drink_count' do
      expect(@bar.drink_count).to eq 2
    end
  end
end
