require 'rails_helper'

RSpec.describe CocktailFacade do
  it '#three_random', :vcr do
    cocktails = CocktailFacade.three_random

    cocktails.each do |cocktail|
      expect(cocktail).to be_a Drink
    end
  end

#   describe 'get_search_results method in the cocktail service' do
#
#     it 'provides a response if no results found in the API', :vcr do
#       expect(CocktailFacade.by_name('gdfjsipgbrqipgbr')).to eq({drinks:nil})
#     end
#
#     it 'can return a response if a partial name is searched', :vcr do
#       expect(CocktailFacade.by_name('gdfjsipgbrqipgbr')).to eq({drinks:nil})
#     end
#
#     it 'can return a response if a drink name is searched with incorrect spelling', :vcr do
#       drinks = CocktailFacade.by_name('nergrene')
# # require "pry"; binding.pry
#       drinks.each do |cocktail|
#         expect(cocktail).to be_a Drink
#       end
#     end
#
#     it 'can return a response if a multi word name is searched' do
#
#     end
#
#     it 'can return a response if a number is searched' do
#
#     end
#
#     it 'can return a response if an empty string is searched' do
#
#     end
#
#     it 'can return a response if multiple fields are quried' do
#
#     end
#
#   end
end
