# frozen_string_literal: true

class SummaryMailer < ApplicationMailer
  def self.send_daily_summaries
    User.where(admin: true).find_each do |admin|
      daily_summaries(admin.email).deliver_later
    end
  end

  def self.send_weekly_summaries
    User.where(admin: true).find_each do |admin|
      weekly_summaries(admin.email).deliver_later
    end
  end

  def daily_summaries(admin_email)
    setup_variables
    mail(to: admin_email, subject: 'Hello!◎每日摘要◎')
  end

  def weekly_summaries(admin_email)
    setup_variables
    mail(to: admin_email, subject: 'Hello!◎每週摘要◎')
  end

  def setup_variables
    @daily_start_date = Time.zone.today.beginning_of_day
    @weekly_start_date = Date.today.beginning_of_week(:sunday)

    @daily_active_users_total = Log.date_range_active_users_total(@daily_start_date)
    @weekly_active_users_total = Log.date_range_active_users_total(@weekly_start_date)

    @daily_booker_total = Log.booking_total_count(@daily_start_date)
    @weekly_booker_total = Log.booking_total_count(@weekly_start_date)

    @booking_durations = Log.booking_duration(@daily_start_date)
    @average_duration = Log.average_duration(@booking_durations)
    @longest_duration = Log.longest_duration(@booking_durations)
  end

end
