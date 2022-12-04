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

      expected = { "data" =>
      { "threeRandomApiDrinks" =>
        [{ "id" => "17065",
           "name" => "Caribbean Boilermaker",
           "imgUrl" => "https://www.thecocktaildb.com/images/media/drink/svsxsv1454511666.jpg" },
         { "id" => "13026",
           "name" => "Sangria The  Best",
           "imgUrl" => "https://www.thecocktaildb.com/images/media/drink/vysywu1468924264.jpg" },
         { "id" => "12724",
           "name" => "Sweet Bananas",
           "imgUrl" => "https://www.thecocktaildb.com/images/media/drink/sxpcj71487603345.jpg" }] } }

      post '/graphql', params: { query: get_random }
      results = JSON.parse(response.body)

      expect(results).to eq(expected)
    end
  end
end
