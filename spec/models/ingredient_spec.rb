require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it { should validate_presence_of :description }
  it { should belong_to :drink }
end
