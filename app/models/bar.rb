class Bar < ApplicationRecord
  validates_presence_of :name
  
  has_many :bar_users
  has_many :users, through: :bar_users
end
