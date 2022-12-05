require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do

  describe 'happy path' do
    before :each do
    end

    it 'can get 3 random drinks fromt the API' do
      drink_1 = Drink.new(id: "17065", name: "Caribbean Boilermaker", img_url: "https://www.thecocktaildb.com/images/media/drink/svsxsv1454511666.jpg")
      drink_2 = Drink.new(id: "13026", name: "Sangria The  Best", img_url: "https://www.thecocktaildb.com/images/media/drink/vysywu1468924264.jpg")
      drink_3 = Drink.new(id: "12724", name: "Sweet Bananas", img_url: "https://www.thecocktaildb.com/images/media/drink/sxpcj71487603345.jpg")

      def get_random
        <<~GQL
        query {
          threeRandomApiDrinks {
            id
            name
            imgUrl
          }
        }
        GQL
      end

      drinks = [drink_1, drink_2, drink_3]

      expected = { "data" =>
      { "threeRandomApiDrinks" =>
        [{ "id" => "#{drink_1.id}",
          "name" => "#{drink_1.name}",
          "imgUrl" => "#{drink_1.img_url}" },
        { "id" => "#{drink_2.id}",
          "name" => "#{drink_2.name}",
          "imgUrl" => "#{drink_2.img_url}" },
        { "id" => "#{drink_3.id}",
          "name" => "#{drink_3.name}",
          "imgUrl" => "#{drink_3.img_url}" }] } }

      allow(CocktailFacade).to receive(:three_random).and_return(drinks)

      post '/graphql', params: { query: get_random }
      results = JSON.parse(response.body)

      expect(results).to eq(expected)
    end
  end
end
