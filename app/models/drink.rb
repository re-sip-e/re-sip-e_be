class Drink < ApplicationRecord
  has_many :ingredients
  belongs_to :bar

  validates_presence_of :name
end
