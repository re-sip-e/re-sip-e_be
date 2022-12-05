class User < ApplicationRecord
  validates_presence_of :name, :email
  validates_uniqueness_of :email

  has_many :bar_users
  has_many :bars, through: :bar_users

  def bar_count
    bars.count
  end
end
