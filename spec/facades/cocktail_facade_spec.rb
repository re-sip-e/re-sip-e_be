require 'rails_helper'

RSpec.describe CocktailFacade do
  it '#three_random', :vcr do
    cocktails = CocktailFacade.three_random

    cocktails.each do |cocktail|
      expect(cocktail).to be_a Drink
    end
  end

end
