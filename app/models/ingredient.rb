class Ingredient < ApplicationRecord
  belongs_to :drink
  validates_presence_of :name
end