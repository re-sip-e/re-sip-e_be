class Drink < ApplicationRecord
  validates_presence_of :name

  belongs_to :bar
  has_many :ingredients, dependent: :destroy
  
  accepts_nested_attributes_for :ingredients, allow_destroy: true

  validate :has_ingredients

  private

  def has_ingredients
    if ingredients.length == 0
      errors.add(:ingredients, "must have at least one ingredient")
    end
  end
end
