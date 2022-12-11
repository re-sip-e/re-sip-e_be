require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do

  describe 'happy path' do
    before :each do
    end

    it 'can get 3 random drinks fromt the API' do
      drink_1 = Drink.new(id: "17065", name: "Caribbean Boilermaker", img_url: "https://www.thecocktaildb.com/images/media/drink/svsxsv1454511666.jpg")
      drink_2 = Drink.new(id: "13026", name: "Sangria The  Best", img_url: "https://www.thecocktaildb.com/images/media/drink/vysywu1468924264.jpg")
      drink_3 = Drink.new(id: "12724", name: "Sweet Bananas", img_url: "https://www.thecocktaildb.com/images/media/drink/sxpcj71487603345.jpg")

      get_random = <<~GQL
        query {
          threeRandomApiDrinks {
            id
            name
            imgUrl
          }
        }
        GQL

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

    describe "Edge Case" do
      it 'If Cocktail DB API is not responsive an Error is returned in GraphQL' do     
        stub_request(:get, "https://www.thecocktaildb.com/api/json/v1/1/random.php").to_return(status: 500)

        get_random_api_down = <<~GQL
        query {
          threeRandomApiDrinks {
            id
            name
            imgUrl
          }
        }
        GQL

        post '/graphql', params: { query: get_random_api_down }
        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(result[:errors][0][:message]).to eq("the server responded with status 500")
      end

      it 'If an Invalid request is sent to the Cocktail DB API a server Error is returned in GraphQL' do     
        stub_request(:get, "https://www.thecocktaildb.com/api/json/v1/1/random.php").to_return(status: 400)

        get_random_api_down = <<~GQL
        query {
          threeRandomApiDrinks {
            id
            name
            imgUrl
          }
        }
        GQL

        post '/graphql', params: { query: get_random_api_down }
        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(result[:errors][0][:message]).to eq("the server responded with status 400")
      end
    end
  end
end
