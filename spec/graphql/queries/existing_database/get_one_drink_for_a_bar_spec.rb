require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do
  before :each do
    @bar = create(:bar)
    @drinks = create_list(:drink, 2, bar: @bar)
    @ingredients1 = create_list(:ingredient, 3, drink: @drinks[0])
    @ingredients2 = create_list(:ingredient, 3, drink: @drinks[1])
  end

  describe 'happy path' do
    it 'can query one drink for a bar' do

      def query_drink
        <<~GQL
          query {
            drink(id: "#{@drinks[0].id}") {
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
                  {"drink" =>
                    {"id" => "#{@drinks[0].id}",
                     "name" => "#{@drinks[0].name}",
                     "imgUrl" =>
                      "#{@drinks[0].img_url}",
                     "steps" => "#{@drinks[0].steps}",
                     "createdAt" => "#{@drinks[0].created_at.iso8601}",
                     "updatedAt" => "#{@drinks[0].updated_at.iso8601}",
                     "bar" => {"id"=>"#{@bar.id}", "name"=>"#{@bar.name}", "drinkCount"=> @bar.drink_count},
                     "ingredients" =>
                      [{"description" => "#{@ingredients1[0].description}",
                        # "quantity" => "#{@ingredients1[0].quantity}",
                        "createdAt" => "#{@ingredients1[0].created_at.iso8601}",
                        "updatedAt" => "#{@ingredients1[0].updated_at.iso8601}"},
                        {"description" => "#{@ingredients1[1].description}",
                         # "quantity" => "#{@ingredients1[1].quantity}",
                         "createdAt" => "#{@ingredients1[1].created_at.iso8601}",
                         "updatedAt" => "#{@ingredients1[1].updated_at.iso8601}"},
                        {"description" => "#{@ingredients1[2].description}",
                         # "quantity" => "#{@ingredients1[2].quantity}",
                         "createdAt" => "#{@ingredients1[2].created_at.iso8601}",
                         "updatedAt" => "#{@ingredients1[2].updated_at.iso8601}"}]
                      }
                    }
                  }

      post '/graphql', params: {query: query_drink}
      result = JSON.parse(response.body)

      expect(response).to be_successful
      expect(result).to eq(expected)
    end
  end

  describe 'sad path' do
    it "gets an error if no drink ID is rec'd"  do
      def query_bad_id_drink
        <<~GQL
          query {
            drink(id: 300) {
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

      post '/graphql', params: {query: query_bad_id_drink}
      result = JSON.parse(response.body)

      expect(result["errors"][0]["message"]).to eq("Couldn't find Drink with 'id'=300")
    end
  end

  describe 'edge case' do
    it 'does not receive error when a field is requested errently twice' do
      def query_double_fields_drink
        <<~GQL
          query {
            drink(id: "#{@drinks[0].id}") {
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
                  {"drink" =>
                    {"id" => "#{@drinks[0].id}",
                     "name" => "#{@drinks[0].name}",
                     "imgUrl" =>
                      "#{@drinks[0].img_url}",
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
                         "updatedAt" => "#{@ingredients1[2].updated_at.iso8601}"}]
                      }
                    }
                  }

      post '/graphql', params: {query: query_double_fields_drink}
      result = JSON.parse(response.body)

      expect(result).to eq(expected)
    end
  end

end
