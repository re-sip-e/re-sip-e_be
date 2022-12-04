require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do

  describe 'happy path' do
    it 'can get 3 random drinks fromt the API', :vcr do
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

      # thoughts on how to make the expected more dynamic?
      expected = {"data"=>
      {"threeRandomApiDrinks"=>
        [{"id"=>"13056",
          "name"=>"Wine Cooler",
          "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/yutxtv1473344210.jpg"},
         {"id"=>"14306",
          "name"=>"Amaretto Stone Sour",
          "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/xwryyx1472719921.jpg"},
         {"id"=>"12714",
          "name"=>"Kiwi Papaya Smoothie",
          "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/jogv4w1487603571.jpg"}]}}

      post '/graphql', params: {query: get_random}
      results = JSON.parse(response.body)

      expect(results).to eq(expected)
    end
  end
end
