require 'rails_helper'

RSpec.describe Types::BarType, type: :request do
  before :each do
    @user = create(:user)
    @bar_1 = create(:bar)
    @bar_user_1= create(:bar_user, bar: @bar_1, user: @user)
    @drink_1 = create(:drink, bar: @bar_1)
    @drink_2 = create(:drink, bar: @bar_1)

    @bar_2 = create(:bar)
    @bar_user_2= create(:bar_user, bar: @bar_2, user: @user)
    @drink_1 = create(:drink, bar: @bar_2)
    @drink_2 = create(:drink, bar: @bar_2)
    @drink_3 = create(:drink, bar: @bar_2)
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
    end
  end

end