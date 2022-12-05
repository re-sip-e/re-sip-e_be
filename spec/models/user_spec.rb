require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should have_many :bar_users }
  it { should have_many(:bars).through(:bar_users) }

  describe 'instance methods' do
    describe '#bar_count' do
      it 'provides the count of bars associated with a given user' do
        user_1 = create(:user)
        user_2 = create(:user)
        user_3 = create(:user)
        bar_user_1 = create(:bar_user, user: user_1)
        bar_user_2 = create_list(:bar_user, 3, user: user_2)
        bar_user_3 = create_list(:bar_user, 5, user: user_3)

        expect(user_1.bar_count).to eq(1)
        expect(user_2.bar_count).to eq(3)
        expect(user_3.bar_count).to eq(5)
      end

      it 'provides a count of 0 if no bars are associated with a given user' do
        user_1 = create(:user)

        expect(user_1.bar_count).to eq(0)
      end
    end
  end
end
