class Drink < ApplicationRecord
  validates_presence_of :name

  belongs_to :bar
  has_many :ingredients, dependent: :destroy
  
  accepts_nested_attributes_for :ingredients, allow_destroy: true
end
