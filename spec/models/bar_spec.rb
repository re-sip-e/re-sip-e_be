require 'rails_helper'

RSpec.describe Bar, type: :model do
  it { should validate_presence_of :name }
  it { should have_many :bar_users }
  it { should have_many(:users).through(:bar_users) }
  it { should have_many :drinks }
end
