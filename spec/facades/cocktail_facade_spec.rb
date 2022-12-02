require 'rails_helper'

RSpec.describe 'cocktail facade' do
  it 'returns some cocktails', :vcr do
    drinks = CocktailFacade.by_name("margarita")
    binding.pry
  end
end