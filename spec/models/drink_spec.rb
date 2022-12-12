require 'rails_helper'

RSpec.describe Drink, type: :model do
  it { should validate_presence_of :name }
  it { should belong_to :bar }
  it { should have_many(:ingredients).dependent(:destroy) }

  it 'validates presense of at least one ingredient' do
    drink = Drink.create(name: "test", steps: "make it", img_url: "img url")
    expect(drink.errors.full_messages).to include("Ingredients must have at least one ingredient")
    expect(Drink.count).to eq(0)

    drink = Drink.create(name: "test", steps: "make it", img_url: "img url", ingredients_attributes: [])
    expect(drink.errors.full_messages).to include("Ingredients must have at least one ingredient")
    expect(Drink.count).to eq(0)
  end
end
