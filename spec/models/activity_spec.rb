require 'rails_helper'
# $bundle exec rspec spec/models/activity_spec.rb
RSpec.describe Activity, type: :model do
  # 確保 factory 建構 Activity Model 實例  
  it "has a valid factory" do
    expect(build(:activity)).to be_valid
  end
  
  # Model 驗證
  describe "validations" do
    it { should validate_presence_of(:title) } 
    it { should validate_presence_of(:description) } 
    it { should validate_presence_of(:start_time) } 
    it { should validate_presence_of(:end_time) } 
    it { should validate_presence_of(:location) } 
    it { should validate_presence_of(:organizer) } 
    it { should validate_presence_of(:max_participants) }
    it { should validate_numericality_of(:max_participants).is_greater_than(5).only_integer }

    context "when end_time <= start_time" do
      it "is not volid" do
        activity = build(:activity, start_time: Time.current, end_time: Time.current - 1.hour)
        activity.valid?
        expect(activity.errors[:end_time]).to include('必須晚於開始時間')
      end

      it "is not volid when start_time = end_time" do
        activity = build(:activity, start_time: Time.zone.parse("2024-03-20 14:00:00"), end_time: Time.zone.parse("2024-03-20 14:00:00"))
        activity.valid?
        expect(activity.errors[:end_time]).to include('必須晚於開始時間')
      end
    end

    context "When end_time > start_time" do
      it "is valid" do
        activity = build(:activity, start_time: Time.current, end_time: Time.current + 1 )
        expect(activity).to be_valid
      end
      
    end
  end

  # Model 關聯
  describe 'associations' do
    it { should have_many(:bookings) } 
    it { should have_many(:logs) } 
    it { should belong_to(:user) } 
  end
  
end
