require 'rails_helper'

RSpec.describe CocktailService do
  it 'will get 3 random drinks', :vcr do
    results = CocktailService.get_three_random

    expect(results).to be_a Array
    expect(results.count).to eq 3
  end
end