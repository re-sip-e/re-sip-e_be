require 'rails_helper'

RSpec.describe Drink, type: :model do
  it { should validate_presence_of :name }
  it { should belong_to :bar }
  it { should have_many :ingredients }
end
