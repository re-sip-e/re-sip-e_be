class Drink < ApplicationRecord
  validates_presence_of :name
  
  belongs_to :bar
end
