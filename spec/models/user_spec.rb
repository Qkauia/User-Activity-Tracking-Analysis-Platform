require 'rails_helper'
# $bundle exec rspec spec/models/user_spec.rb
RSpec.describe User, type: :model do
  # 確保 factory 建構 User Model 實例  
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  # 測試 Model驗證
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  # 測試 model關聯
  describe 'associations' do
    it { should have_many(:logs) }
    it { should have_many(:bookings) }
    it { should have_many(:activities) }
  end

  # 測試 already_booked? 方法
  describe '#already_booked?' do
    let(:user) { create(:user) }
    let(:activity) { create(:activity) }

    context 'when the user has booked the activity' do
      before do
        create(:booking, user: user, activity: activity)
      end

      it 'returns true' do
        expect(user.already_booked?(activity)).to be_truthy
      end
    end

    context 'when the user has not booked the activity' do
      it 'returns false' do
        expect(user.already_booked?(activity)).to be_falsey
      end
    end
  end
end
