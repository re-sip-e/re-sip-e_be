require 'rails_helper'

RSpec.describe 'adding a drink to a bar' do
  describe 'happy path' do
    it 'can add a drink with ingredients to a bar' do
      bar = create(:bar)

      def create_drink_mutation
        <<~GQL
          mutation {
            createDrink(input:{
              name:"Negroni"
              imgUrl:"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg"
              steps:"Stir into glass over ice, garnish and serve."
              barId: "#{bar.id}"
              ingredients:[
                {
                  name:"Gin"
                  quantity:"1 oz"
                }
                {
                  name:"Campari"
                  quantity:"1 oz"
                }
                {
                  name:"Sweet Vermouth"
                  quantity:"1 oz"
                }
              ]
            }){
              drink{
                id
                name
                steps
                imgUrl
                createdAt
                updatedAt
                ingredients{
                  name
                  id
                  quantity
                }
              }
              errors
            }
          }
        GQL
      end

      post '/graphql', params: {queryS: create_drink_mutation}

      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)
      created_drink = Drink.last

      expect(created_drink.bar).to eq(bar)

      expect(created_drink.name).to eq("Negroni")
      expect(created_drink.img_url).to eq("https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg")
      expect(created_drink.steps).to eq("Stir into glass over ice, garnish and serve.")
      expect(created_drink.name).to eq("Negroni")

      expect(created_drink.ingredients[0].name).to eq("Gin")
      expect(created_drink.ingredients[0].quantity).to eq("1 oz")

      expect(created_drink.ingredients[1].name).to eq("Campari")
      expect(created_drink.ingredients[1].quantity).to eq("1 oz")

      expect(created_drink.ingredients[2].name).to eq("Sweet Vermouth")
      expect(created_drink.ingredients[2].quantity).to eq("1 oz")
      
      expected_result = {
        data: {
          drink: {
            id: created_drink.id.to_s,
            name: created_drink.name,
            step: created_drink.steps,
            imgUrl: created_drink.img_url,
            createdAt: created_drink.created_at,
            updatedAt: created_drink.updated_at,
            ingredients: [
              {
                name: created_drink.ingredients[0].name,
                quantity: created_drink.ingredients[0].quantity
              },
              {
                name: created_drink.ingredients[1].name,
                quantity: created_drink.ingredients[1].quantity
              },
              {
                name: created_drink.ingredients[2].name,
                quantity: created_drink.ingredients[2].quantity
              }
            ]
          },
          errors: []
        }
      }

      expect(result).to eq(expected_result)
    end
  end
end