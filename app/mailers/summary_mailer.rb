# frozen_string_literal: true

class SummaryMailer < ApplicationMailer
  def self.send_daily_summaries
    User.where(admin: true).find_each do |admin|
      daily_summaries(admin.email, admin.name).deliver_later
    end
  end

  def self.send_weekly_summaries
    User.where(admin: true).find_each do |admin|
      weekly_summaries(admin.email, admin.name).deliver_later
    end
  end

  def daily_summaries(admin_email, admin_name)
    setup_variables
    mail(to: admin_email, subject: "Hello!#{admin_name}先生 / 女士 ◎每日摘要◎")
  end

  def weekly_summaries(admin_email, admin_name)
    setup_variables
    mail(to: admin_email, subject: "Hello!#{admin_name}先生 / 女士 ◎每週摘要◎")
  end

  def setup_variables
    @time_now = Time.zone.today
    @yesterday = Time.zone.yesterday
    @daily_date_range = Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day
    @weekly_date_range = 1.week.ago.beginning_of_week(:sunday)..Time.zone.yesterday.end_of_day

    @daily_active_users_total = Log.date_range_active_users_total(@daily_date_range)
    @weekly_active_users_total = Log.date_range_active_users_total(@weekly_date_range)

    @daily_booker_total = Log.booking_total_count(@daily_date_range)
    @weekly_booker_total = Log.booking_total_count(@weekly_date_range)

    @booking_durations = Log.booking_duration(@daily_date_range)
    @average_duration = Log.average_duration(@booking_durations)
    @longest_duration = Log.longest_duration(@booking_durations)
  end
end
