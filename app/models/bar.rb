class Bar < ApplicationRecord
  validates_presence_of :name
  
  has_many :bar_users
  has_many :users, through: :bar_users
  has_many :drinks

  def drink_count
    drinks.count
  end
end
