class Bar < ApplicationRecord
  validates_presence_of :name

  has_many :bar_users
  has_many :users, through: :bar_users
  has_many :drinks

  after_create :add_angel_shot

  def drink_count
    drinks.count
  end

  private

  def add_angel_shot
    drinks.create(
      name: "Angel Shot",
      img_url: "https://vinepair.com/wp-content/uploads/2022/03/angel-shot_card.jpg",
      steps: "If someone orders an Angel Shot, it means they need help from the bartender.\n\nStraight-up/Neat: Customer needs an escort to their car.\nOn the Rocks: Customers needs a discretely ordered cab.\nWith Lime: Customer needs you to call the police.",
      ingredients_attributes: [
        {
          description: "N/A - See Steps"
        }
      ]
    )
  end
end
