require 'rails_helper'

RSpec.describe BarUser, type: :model do
  it { should belong_to :bar }
  it { should belong_to :user }
end
