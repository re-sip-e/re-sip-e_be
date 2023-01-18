require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do
  before :each do
    @bar = create(:bar)
    @bar.drinks.destroy_all
    @drinks = create_list(:drink, 2, bar: @bar)
    @ingredients1 = @drinks[0].ingredients
    @ingredients2 = @drinks[1].ingredients
  end

  describe 'happy path' do
    it 'can query all drinks for a bar' do
      def query_drinks
        <<~GQL
          query {
            drinks(barId: "#{@bar.id}") {
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
                description
                createdAt
                updatedAt
              }
            }
          }
        GQL
      end
      expected = {"data" =>
      {"drinks" =>
        [{"id" => "#{@drinks[0].id}",
          "name" => "#{@drinks[0].name}",
          "imgUrl" => "#{@drinks[0].img_url}",
          "steps" => "#{@drinks[0].steps}",
          "createdAt" => "#{@drinks[0].created_at.iso8601}",
          "updatedAt" => "#{@drinks[0].updated_at.iso8601}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=> @bar.drink_count},
          "ingredients" =>
        [{"description" => "#{@ingredients1[0].description}",
          "createdAt" => "#{@ingredients1[0].created_at.iso8601}",
          "updatedAt" => "#{@ingredients1[0].updated_at.iso8601}"},
         {"description" => "#{@ingredients1[1].description}",
          "createdAt" => "#{@ingredients1[1].created_at.iso8601}",
          "updatedAt" => "#{@ingredients1[1].updated_at.iso8601}"},
         {"description" => "#{@ingredients1[2].description}",
          "createdAt" => "#{@ingredients1[2].created_at.iso8601}",
          "updatedAt" => "#{@ingredients1[2].updated_at.iso8601}"}]},
         {"id" => "#{@drinks[1].id}",
          "name" => "#{@drinks[1].name}",
          "imgUrl" => "#{@drinks[1].img_url}",
          "steps" => "#{@drinks[1].steps}",
          "createdAt" => "#{@drinks[1].created_at.iso8601}",
          "updatedAt" => "#{@drinks[1].updated_at.iso8601}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=>@bar.drink_count},
          "ingredients" =>
         [{"description" => "#{@ingredients2[0].description}",
           "createdAt" => "#{@ingredients2[0].created_at.iso8601}",
           "updatedAt" => "#{@ingredients2[0].updated_at.iso8601}"},
          {"description" => "#{@ingredients2[1].description}",
           "createdAt" => "#{@ingredients2[1].created_at.iso8601}",
           "updatedAt" => "#{@ingredients2[1].updated_at.iso8601}"},
          {"description" => "#{@ingredients2[2].description}",
           "createdAt" => "#{@ingredients2[2].created_at.iso8601}",
           "updatedAt" => "#{@ingredients2[2].updated_at.iso8601}"}]}]}}

      post '/graphql', params: {query: query_drinks}
      results = JSON.parse(response.body)

      expect(response).to be_successful
      expect(results).to eq(expected)
    end
  end

  describe 'sad path' do
    it 'returns an error if bar ID does not exist' do
      def query_bad_bar_id_drinks
        <<~GQL
          query {
            drinks(barId: 300) {
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
                description
                createdAt
                updatedAt
              }
            }
          }
        GQL
      end

      post '/graphql', params: {query: query_bad_bar_id_drinks}
      results = JSON.parse(response.body)

      expect(results["errors"][0]["message"]).to eq("Couldn't find Bar with 'id'=300")
    end
  end

  describe 'edge case' do
    it 'will return results even if duplicate fields are queried' do
      def query_dup_fields_for_bar_drinks
        <<~GQL
          query {
            drinks(barId: "#{@bar.id}") {
              id
              id
              name
              name
              imgUrl
              imgUrl
              steps
              steps
              createdAt
              createdAt
              updatedAt
              updatedAt
              bar {
                id
                name
                drinkCount
              }
              bar {
                id
                name
                drinkCount
              }
              ingredients {
                description
                createdAt
                updatedAt
              }
              ingredients {
                description
                createdAt
                updatedAt
              }
            }
          }
        GQL
      end

      expected = {"data" =>
      {"drinks" =>
        [{"id" => "#{@drinks[0].id}",
          "name" => "#{@drinks[0].name}",
          "imgUrl" => "#{@drinks[0].img_url}",
          "steps" => "#{@drinks[0].steps}",
          "createdAt" => "#{@drinks[0].created_at.iso8601}",
          "updatedAt" => "#{@drinks[0].updated_at.iso8601}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=> @bar.drink_count},
          "ingredients" =>
        [{"description" => "#{@ingredients1[0].description}",
          "createdAt" => "#{@ingredients1[0].created_at.iso8601}",
          "updatedAt" => "#{@ingredients1[0].updated_at.iso8601}"},
         {"description" => "#{@ingredients1[1].description}",
          "createdAt" => "#{@ingredients1[1].created_at.iso8601}",
          "updatedAt" => "#{@ingredients1[1].updated_at.iso8601}"},
         {"description" => "#{@ingredients1[2].description}",
          "createdAt" => "#{@ingredients1[2].created_at.iso8601}",
          "updatedAt" => "#{@ingredients1[2].updated_at.iso8601}"}]},
         {"id" => "#{@drinks[1].id}",
          "name" => "#{@drinks[1].name}",
          "imgUrl" => "#{@drinks[1].img_url}",
          "steps" => "#{@drinks[1].steps}",
          "createdAt" => "#{@drinks[1].created_at.iso8601}",
          "updatedAt" => "#{@drinks[1].updated_at.iso8601}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=>@bar.drink_count},
          "ingredients" =>
         [{"description" => "#{@ingredients2[0].description}",
           "createdAt" => "#{@ingredients2[0].created_at.iso8601}",
           "updatedAt" => "#{@ingredients2[0].updated_at.iso8601}"},
          {"description" => "#{@ingredients2[1].description}",
           "createdAt" => "#{@ingredients2[1].created_at.iso8601}",
           "updatedAt" => "#{@ingredients2[1].updated_at.iso8601}"},
          {"description" => "#{@ingredients2[2].description}",
           "createdAt" => "#{@ingredients2[2].created_at.iso8601}",
           "updatedAt" => "#{@ingredients2[2].updated_at.iso8601}"}]}]}}

      post '/graphql', params: {query: query_dup_fields_for_bar_drinks}
      results = JSON.parse(response.body)

      expect(results).to eq(expected)
    end
  end

end
