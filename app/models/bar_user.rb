class BarUser < ApplicationRecord
  belongs_to :bar
  belongs_to :user
end
