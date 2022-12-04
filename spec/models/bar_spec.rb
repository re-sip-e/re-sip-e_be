require 'rails_helper'

RSpec.describe Bar, type: :model do
  it { should validate_presence_of :name }
end
