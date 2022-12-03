require 'rails_helper'

RSpec.describe 'cocktail facade' do
  it 'returns some cocktails', :vcr do
    drinks = CocktailFacade.by_name("margarita")
    binding.pry
  end

  it 'returns one cocktail', :vcr do
    drink = CocktailFacade.cocktail_by_id("11003")
    binding.pry
  end
end