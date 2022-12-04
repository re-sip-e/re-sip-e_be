require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do
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

  describe 'happy path' do
    describe 'get one drink for a bar' do
      it 'can query one drink for a bar' do

        def query_drink
          <<~GQL
          query {
            drink(id: "#{@drink_1.id}") {
              id
              name
              imgUrl
              steps
              createdAt
              updatedAt
              bar {
                id
                name
                drinkCount
              }
              ingredients {
                name
                quantity
                createdAt
                updatedAt
              }
            }
          }
          GQL
        end

        expected = {"data"=>
                    {"drink"=>
                      {"id"=>"#{@drink_1.id}",
                      "name"=>"#{@drink_1.name}",
                      "imgUrl"=>
                        "#{@drink_1.img_url}",
                      "steps"=>"#{@drink_1.steps}",
                      "createdAt"=>"#{@drink_1.created_at.iso8601}",
                      "updatedAt"=>"#{@drink_1.updated_at.iso8601}",
                      "bar"=>{"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=>"#{@bar.drink_count}"},
                      "ingredients"=>
                        [{"name"=>"#{@ingredient_1.name}",
                          "quantity"=>"#{@ingredient_1.quantity}",
                          "createdAt"=>"#{@ingredient_1.created_at.iso8601}",
                          "updatedAt"=>"#{@ingredient_1.updated_at.iso8601}"},
                          {"name"=>"#{@ingredient_2.name}",
                          "quantity"=>"#{@ingredient_2.quantity}",
                          "createdAt"=>"#{@ingredient_2.created_at.iso8601}",
                          "updatedAt"=>"#{@ingredient_2.updated_at.iso8601}"},
                          {"name"=>"#{@ingredient_3.name}",
                          "quantity"=>"#{@ingredient_3.quantity}",
                          "createdAt"=>"#{@ingredient_3.created_at.iso8601}",
                          "updatedAt"=>"#{@ingredient_3.updated_at.iso8601}"}]
                        }
                      }
                    }

        post '/graphql', params: {query: query_drink}
        result = JSON.parse(response.body)

        expect(response).to be_successful
        expect(result).to eq(expected)
      end
    end
  end


end