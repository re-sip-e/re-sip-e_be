require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do

  before :each do

  end

  describe 'happy path' do
    it 'can find drinks by name from api', :vcr do

      def query_drinks
        <<~GQL
        query {
          apiDrinks(query: "negroni") {
            id
            name
            imgUrl
            steps
            ingredients {
              name
              quantity
            }
          }
        }
        GQL
      end
  # require "pry"; binding.pry
      expected = {"data"=>
        {"apiDrinks"=>
          [{"id"=>"11003",
            "name"=>"Negroni",
            "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
            "steps"=>"Stir into glass over ice, garnish and serve.",
            "ingredients"=>[{"name"=>"Gin", "quantity"=>"1 oz "}, {"name"=>"Campari", "quantity"=>"1 oz "}, {"name"=>"Sweet Vermouth", "quantity"=>"1 oz "}]},
           {"id"=>"17248",
            "name"=>"French Negroni",
            "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/x8lhp41513703167.jpg",
            "steps"=>
             "Add ice to a shaker and pour in all ingredients.\nUsing a bar spoon, stir 40 to 45 revolutions or until thoroughly chilled.\nStrain into a martini glass or over ice into a rocks glass. Garnish with orange twist.",
            "ingredients"=>
             [{"name"=>"Gin", "quantity"=>"1 oz"},
              {"name"=>"Lillet", "quantity"=>"1 oz"},
              {"name"=>"Sweet Vermouth", "quantity"=>"1 oz"},
              {"name"=>"Orange Peel", "quantity"=>"1"}]},
           {"id"=>"178340",
            "name"=>"Garibaldi Negroni",
            "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/kb4bjg1604179771.jpg",
            "steps"=>"Mix together in a shaker and garnish with a simple orange slice. Fill your vitamin C and cocktail fix at the same time!",
            "ingredients"=>
             [{"name"=>"Gin", "quantity"=>"30 ml"},
              {"name"=>"Campari", "quantity"=>"30 ml"},
              {"name"=>"Orange Juice", "quantity"=>"90 ml"},
              {"name"=>"Orange Peel", "quantity"=>"Garnish with"}]}]}}

      post '/graphql', params: {query: query_drinks}
      result = JSON.parse(response.body)
      expect(response).to be_successful
      expect(result).to eq(expected)

    end
  end


end
