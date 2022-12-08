require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do

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
              description
            }
          }
        }
        GQL
      end

      expected = {"data" => {
        "apiDrinks"=>[{
          "id"=>"11003",
          "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
          "ingredients"=>[{
            "description"=>"1 oz  Gin"}, {
            "description"=>"1 oz  Campari"}, {
            "description"=>"1 oz  Sweet Vermouth"}],
          "name"=>"Negroni",
          "steps"=>"Stir into glass over ice, garnish and serve."}, {
          "id"=>"17248",
          "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/x8lhp41513703167.jpg",
          "ingredients"=>[{
            "description"=>"1 oz Gin"}, {
            "description"=>"1 oz Lillet"}, {
            "description"=>"1 oz Sweet Vermouth"}, {
            "description"=>"1 Orange Peel"}],
          "name"=>"French Negroni",
          "steps"=>"Add ice to a shaker and pour in all ingredients.\nUsing a bar spoon, stir 40 to 45 revolutions or until thoroughly chilled.\nStrain into a martini glass or over ice into a rocks glass. Garnish with orange twist."}, {
          "id"=>"178340",
          "imgUrl"=>"https://www.thecocktaildb.com/images/media/drink/kb4bjg1604179771.jpg",
          "ingredients"=>[{
            "description"=>"30 ml Gin"}, {
            "description"=>"30 ml Campari"}, {
            "description"=>"90 ml Orange Juice"}, {
            "description"=>"Garnish with Orange Peel"}],
          "name"=>"Garibaldi Negroni",
          "steps"=>"Mix together in a shaker and garnish with a simple orange slice. Fill your vitamin C and cocktail fix at the same time!"
      }]}}

      post '/graphql', params: {query: query_drinks}
      result = JSON.parse(response.body)
      expect(response).to be_successful
      expect(result).to eq(expected)

    end
  end


end
