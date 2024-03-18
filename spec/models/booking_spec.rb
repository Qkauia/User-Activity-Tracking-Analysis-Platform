require 'rails_helper'
# $bundle exec rspec spec/models/booking_spec.rb
RSpec.describe Booking, type: :model do
  # 確保 factory 建構 Booking Model 實例
  it "has a valid factory" do
    expect(build(:booking)).to be_valid
  end

  # Model 驗證
  describe "validations" do
    it { should validate_presence_of(:booker_name)}
    it { should validate_presence_of(:booker_email).with_message("E-Mail格式輸入錯誤")}
  end

    
  describe 'scope validations' do
    subject { FactoryBot.create(:booking) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:activity_id).with_message('你已經參加了！') }
  end

  # Model 關聯
  describe "associations" do
    it { should have_many(:logs) }
    it { should belong_to(:user) }
    it { should belong_to(:activity) } 
  end

  describe "email format" do
    let(:valid_email) { "test@example.com"}
    let(:invalid_email) { "invalid_mail"}

    it "is valid with valid email" do
      booking = build(:booking, booker_email: valid_email)
      expect(booking).to be_valid
    end

    it "is invalid with invalid email" do
      booking = build(:booking, booker_email: invalid_email)
      booking.valid?
      expect(booking.errors[:booker_email]).to include("E-Mail格式輸入錯誤")
    end

  end

  describe "booking deleted scope" do
    before do
      @booking = create(:booking, deleted_at: nil)
      @booking2 = create(:booking, deleted_at: nil)

      @booking_deleted = create(:booking, deleted_at: Time.current)
    end
    
    it "includes booking with deleted_at nil" do
      expect(Booking.booking).to include(@booking, @booking2)
    end

    it "include booking with deleted_at not nil" do
      expect(Booking.booking).not_to include(@booking_deleted)
    end
  end

end
