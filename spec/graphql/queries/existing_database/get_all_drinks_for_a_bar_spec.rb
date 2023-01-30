require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do
  before :each do
    @bar = create(:bar)
    @bar.drinks.first.destroy
    
    @drink_1 = create(:drink, name: "Aviation", bar: @bar)
    @drink_2 = create(:drink, name: "Margarita", bar: @bar)
    @ingredients1 = @drink_1.ingredients
    @ingredients2 = @drink_2.ingredients
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
        [{"id" => "#{@drink_1.id}",
          "name" => "#{@drink_1.name}",
          "imgUrl" => "#{@drink_1.img_url}",
          "steps" => "#{@drink_1.steps}",
          "createdAt" => "#{@drink_1.created_at.iso8601}",
          "updatedAt" => "#{@drink_1.updated_at.iso8601}",
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
         {"id" => "#{@drink_2.id}",
          "name" => "#{@drink_2.name}",
          "imgUrl" => "#{@drink_2.img_url}",
          "steps" => "#{@drink_2.steps}",
          "createdAt" => "#{@drink_2.created_at.iso8601}",
          "updatedAt" => "#{@drink_2.updated_at.iso8601}",
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

    it 'returns all drinks for a bar in alphabetical order' do
      @bar.drinks.destroy_all
      @drink_1 = create(:drink, name: "Whiskey Sour", bar: @bar)
      @drink_2 = create(:drink, name: "Bloody Mary", bar: @bar)
      @drink_3 = create(:drink, name: "Bee's Knees", bar: @bar)
      @drink_4 = create(:drink, name: "Manhattan", bar: @bar)

      def query_drinks
        <<~GQL
          query {
            drinks(barId: "#{@bar.id}") {
              id
              name
              bar {
                id
                name
                drinkCount
              }
            }
          }
        GQL
      end
      expected = {"data" =>
      {"drinks" =>
        [{"id" => "#{@drink_3.id}",
          "name" => "#{@drink_3.name}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=> @bar.drink_count}},
         {"id" => "#{@drink_2.id}",
          "name" => "#{@drink_2.name}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=>@bar.drink_count}},
          {"id" => "#{@drink_4.id}",
          "name" => "#{@drink_4.name}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=>@bar.drink_count}},
          {"id" => "#{@drink_1.id}",
          "name" => "#{@drink_1.name}",
          "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=>@bar.drink_count}}]}}

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
        [{"id" => "#{@drink_1.id}",
          "name" => "#{@drink_1.name}",
          "imgUrl" => "#{@drink_1.img_url}",
          "steps" => "#{@drink_1.steps}",
          "createdAt" => "#{@drink_1.created_at.iso8601}",
          "updatedAt" => "#{@drink_1.updated_at.iso8601}",
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
         {"id" => "#{@drink_2.id}",
          "name" => "#{@drink_2.name}",
          "imgUrl" => "#{@drink_2.img_url}",
          "steps" => "#{@drink_2.steps}",
          "createdAt" => "#{@drink_2.created_at.iso8601}",
          "updatedAt" => "#{@drink_2.updated_at.iso8601}",
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
