# frozen_string_literal: true

require 'rails_helper'
# $bundle exec rspec spec/models/log_spec.rb
# include FactoryBot::Syntax::Methods
RSpec.describe Log, type: :model do
  it 'has a valid factory' do
    expect(build(:log)).to be_valid
  end

  # Model 關連
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:activity).optional }
    it { should belong_to(:booking).optional }
  end

  describe '.date_range_active_users_total' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    let!(:activity1) { create(:activity, user: user1, created_at: 2.days.ago) }
    let!(:booking1) { create(:booking, user: user1, activity: activity1, created_at: 2.days.ago) }
    let!(:log1) do
      create(:log, user: user1, booking: booking1, activity: activity1, type: '預訂送出', created_at: 2.days.ago)
    end

    let!(:activity2) { create(:activity, user: user2, created_at: 10.days.ago) }
    let!(:booking2) { create(:booking, user: user2, activity: activity2, created_at: 10.days.ago) }
    let!(:log2) do
      create(:log, user: user2, booking: booking2, activity: activity2, type: '預訂送出', created_at: 10.days.ago)
    end

    let(:not_daily_date_range) { 3.days.ago..1.day.ago }
    let(:daily_date_range) { Time.zone.today.beginning_of_day..Time.zone.today.end_of_day }

    it 'returns the total number of unique active users within the given not daily date range' do
      result = Log.date_range_active_users_total(not_daily_date_range)
      expect(result).to eq(1)
    end

    it 'returns the total number of unique active users within the given daily date range' do
      result = Log.date_range_active_users_total(daily_date_range)
      expect(result).to eq(0)
    end
  end

  describe '.booking_total_count' do
    let(:date_range) { 2.days.ago.beginning_of_day..Time.zone.now.end_of_day }

    before do
      create(:log, type: 'submitted', created_at: 1.day.ago)
      create(:log, type: 'submitted', created_at: 1.day.ago)

      create(:log, type: 'cancel_booking', created_at: 1.day.ago)
    end

    it 'correctly calculates the booking total count' do
      expect(Log.booking_total_count(date_range)).to eq(1)
    end

    context 'with no logs in the date range' do
      let(:date_range) { 5.days.ago..3.days.ago }

      it 'returns zero' do
        expect(Log.booking_total_count(date_range)).to eq(0)
      end
    end
  end

  describe '.booking_duration' do
    let(:date_range) { 3.days.ago..1.day.ago }

    before do
      create(:log, type: 'browse_activity_show', created_at: 2.days.ago)
      create(:log, type: 'email_field_changed', created_at: 2.days.ago + 1.hours)
      create(:log, type: 'submitted', created_at: 2.days.ago + 3.hours)

      # 其他id沒有連貫的log記錄
      create(:log, type: 'browse_activity_show', created_at: 5.days.ago)
      create(:log, type: 'submitted', created_at: 4.days.ago)
    end

    it 'returns an array of durations between matching logs within the given date range' do
      durations = Log.booking_duration(date_range)
      expect(durations.length).to eq(1)
      # 結果容錯在3小時上下5秒
      expect(durations.first).to be_within(5.second).of(3.hours)
    end
  end

  describe '.average_duration' do
    it 'returns nil for empty array' do
      expect(Log.average_duration([])).to be_nil
    end

    it 'calculates the average duration in minutes' do
      durations = [120.00, 180.00, 240.11] # 540.11
      expect(Log.average_duration(durations)).to eq(3.00) # 平均每项3分钟
    end
  end

  describe '.longest_duration' do
    it 'returns nil for empty array' do
      expect(Log.longest_duration([])).to be_nil
    end

    it 'identifies the longest duration in minutes' do
      durations = [120, 180, 240] # 240
      expect(Log.longest_duration(durations)).to eq(4.00) # 最長預約時長4分鐘
    end
  end
end
