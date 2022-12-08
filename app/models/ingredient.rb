class Ingredient < ApplicationRecord
  validates_presence_of :description

  belongs_to :drink
end
