require 'rails_helper'

RSpec.describe Types::BarType, type: :request do
  before :each do
    @user = create(:user)
    @bar_1 = create(:bar)
    @bar_user_1= create(:bar_user, bar: @bar_1, user: @user)
    @bar_1.drinks.destroy_all
    @drink_1 = create(:drink, bar: @bar_1)
    @drink_2 = create(:drink, bar: @bar_1)

    @bar_2 = create(:bar)
    @bar_user_2= create(:bar_user, bar: @bar_2, user: @user)
    @bar_2.drinks.destroy_all
    @drink_3 = create(:drink, bar: @bar_2)
    @drink_4 = create(:drink, bar: @bar_2)
    @drink_5 = create(:drink, bar: @bar_2)
  end

  describe 'happy path' do
    describe 'get info for a bar' do
      it 'can query for info on one bar using the bar id' do

        def query_bar
          <<~GQL
          query {
            bar(id: "#{@bar_1.id}") {
              id
              name
              drinkCount
            }
          }
          GQL
        end

        expected = { "data": {
                      "bar": {
                        "id": "#{@bar_1.id}",
                        "name": "#{@bar_1.name}",
                        "drinkCount": @bar_1.drink_count}
                      }
                    }

        post '/graphql', params: {query: query_bar}
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(result).to eq(expected)
        expect(result[:data][:name]).to_not eq(@bar_2.name)
      end

      it 'can query for all the drinks at a bar when getting a bars info' do

        def query_bar
          <<~GQL
          query {
            bar(id: "#{@bar_2.id}") {
              id
              name
              drinkCount
              drinks{
                name
              }
            }
          }
          GQL
        end

        expected = { "data": {
                      "bar": {
                        "id": "#{@bar_2.id}",
                        "name": "#{@bar_2.name}",
                        "drinkCount": @bar_2.drink_count,
                        "drinks": [
                          {"name": "#{@drink_3.name}"},
                          {"name": "#{@drink_4.name}"},
                          {"name": "#{@drink_5.name}"}
                        ]}
                      }
                    }

        post '/graphql', params: {query: query_bar}
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(result).to eq(expected)
        expect(result[:data][:name]).to_not eq(@bar_1.name)
      end
      
    end
  end

  describe 'sad path' do
    it 'returns an error when requesting info for a bar ID that does not exist' do
      def query_bad_id_bar
        <<~GQL
        query {
          bar(id: 199) {
            id
            name
            drinkCount
            drinks{
              name
            }
          }
        }
        GQL
      end

      expected = {:data=>nil,
      :errors=>
       [{:message=>"Couldn't find Bar with 'id'=199",
         :locations=>[{:line=>2, :column=>3}],
         :path=>["bar"]}]}

      post '/graphql', params: {query: query_bad_id_bar}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to eq(expected)
    end

    it 'returns and error when querying for drinks with a bar id that doesnt exist' do
      def query_bad_id_bar_drinks
        <<~GQL
        query {
          bar(id: 100) {
            id
            name
            drinkCount
            drinks{
              name
            }
          }
        }
        GQL
      end

      expected = {:data=>nil,
      :errors=>
       [{:message=>"Couldn't find Bar with 'id'=100",
         :locations=>[{:line=>2, :column=>3}],
         :path=>["bar"]}]}

      post '/graphql', params: {query: query_bad_id_bar_drinks}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to eq(expected)
    end
  end

  describe 'edge case' do
    it 'does not receive an error when a field is requested errently twice for a bar' do
      def query_dup_field_bar
        <<~GQL
        query {
          bar(id: "#{@bar_1.id}") {
            id
            id
            name
            name
            drinkCount
            drinkCount
          }
        }
        GQL
      end

      expected = { "data": {
        "bar": {
          "id": "#{@bar_1.id}",
          "name": "#{@bar_1.name}",
          "drinkCount": @bar_1.drink_count}
        }
      }

      post '/graphql', params: {query: query_dup_field_bar}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to eq(expected)
      expect(result[:data][:name]).to_not eq(@bar_2.name)
    end

    it 'does not receive an error when duplicate fields are used in the request for a bars drinks' do
      def query_dup_fields_bar_drinks
        <<~GQL
        query {
          bar(id: "#{@bar_2.id}") {
            id
            id
            name
            name
            drinkCount
            drinkCount
            drinks{
            name
              name
            }
          }
        }
        GQL
      end

      expected = { "data": {
        "bar": {
          "id": "#{@bar_2.id}",
          "name": "#{@bar_2.name}",
          "drinkCount": @bar_2.drink_count,
          "drinks": [
            {"name": "#{@drink_3.name}"},
            {"name": "#{@drink_4.name}"},
            {"name": "#{@drink_5.name}"}
          ]}
        }
      }


      post '/graphql', params: {query: query_dup_fields_bar_drinks}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to eq(expected)
    end
  end

end