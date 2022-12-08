require 'rails_helper'

RSpec.describe Types::UserType, type: :request do
  before :each do
    @user = create(:user)

    @bar_1 = create(:bar)
    @bar_user_1 = create(:bar_user, bar: @bar_1, user: @user)
    create_list(:drink, 2, bar: @bar_1)

    @bar_2 = create(:bar)
    @bar_user_2 = create(:bar_user, bar: @bar_2, user: @user)
    create_list(:drink, 3, bar: @bar_2)
  end

  describe 'happy path' do
    describe 'get info for a user' do
      it 'can query for info about a user using the users id' do
        def query_user
          <<~GQL
            query {
              user(id: "#{@user.id}") {
                id
                name
                barCount
                createdAt
              }
            }
          GQL
        end

        expected = { "data": {
          "user": {
            "id": "#{@user.id}",
            "name": "#{@user.name}",
            "barCount": @user.bar_count,
            "createdAt": "#{@user.created_at.iso8601}"
          }
        } }

        post '/graphql', params: { query: query_user }
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(result).to eq(expected)
      end

      it 'can query for all the bars associated with a user when getting user info' do
        def query_user
          <<~GQL
            query {
              user(id: "#{@user.id}") {
                id
                name
                barCount
                createdAt
                bars {
                id
                name
                drinkCount
                }
              }
            }
          GQL
        end

        expected = { "data": {
          "user": {
            "id": "#{@user.id}",
            "name": "#{@user.name}",
            "barCount": @user.bar_count,
            "createdAt": "#{@user.created_at.iso8601}",
            "bars": [
              { "id": "#{@bar_1.id}",
                "name": "#{@bar_1.name}",
                "drinkCount": @bar_1.drink_count },
              { "id": "#{@bar_2.id}",
                "name": "#{@bar_2.name}",
                "drinkCount": @bar_2.drink_count }
            ]
          }
        } }

        post '/graphql', params: { query: query_user }
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(result).to eq(expected)
        expect(result[:data][:name]).to_not eq(@bar_1.name)
      end
    end
  end

  describe 'sad path' do
    it 'will return an error if the wrong user id is used' do
      def query_bad_id_user
        <<~GQL
          query {
            user(id: 9999) {
              id
              name
              barCount
              createdAt
            }
          }
        GQL
      end

      expected = { :data => nil,
                  :errors =>
                  [{ :message => "Couldn't find User with 'id'=9999",
                    :locations => [{ :line=>2, :column=>3 }],
                    :path => ["user"] }] }

      post '/graphql', params: { query: query_bad_id_user }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to eq(expected)
    end

    it 'will return an error when using the wrong user_id when querying for bars associated to user' do
      def query_bad_id_user_bars
        <<~GQL
          query {
            user(id: 9999) {
              id
              name
              barCount
              createdAt
              bars {
              id
              name
              drinkCount
              }
            }
          }
        GQL
      end

      expected = { :data => nil,
                  :errors =>
                  [{ :message => "Couldn't find User with 'id'=9999",
                    :locations => [{ :line=>2, :column=>3 }],
                    :path => ["user"] }] }

      post '/graphql', params: { query: query_bad_id_user_bars }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to eq(expected)
    end
  end
end
