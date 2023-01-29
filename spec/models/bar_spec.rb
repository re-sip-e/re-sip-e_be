require 'rails_helper'

RSpec.describe Bar, type: :model do
  it { should validate_presence_of :name }
  it { should have_many :bar_users }
  it { should have_many(:users).through(:bar_users) }
  it { should have_many :drinks }

  it 'has an angel shot upon creation' do
    bar = create(:bar)

    expect(bar.drinks.length).to eq(1)

    angel_shot = bar.drinks.first

    expect(angel_shot.steps).to eq("If someone orders an Angel Shot, it means they need help from the bartender.\n\nStraight-up/Neat: Customer needs an escort to their car.\nOn the Rocks: Customers needs a discretely ordered cab.\nWith Lime: Customer needs you to call the police.")
    expect(angel_shot.name).to eq("Angel Shot")
    expect(angel_shot.ingredients.length).to eq(1)
  end
end
