# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.includes(:logs).all.sort_by { |user| user.logs.last&.created_at || Time.current }.reverse
  end

  def show
    @user = User.includes(:logs).find(params[:id])
    @logs = @user.logs.order(created_at: :desc)
    authorize @user

    daily_date_range = Time.zone.today.beginning_of_day..Time.zone.today.end_of_day
    weekly_date_range = Time.zone.today.beginning_of_week(:sunday)..Time.zone.today.end_of_day

    @daily_active_users_total = Log.date_range_active_users_total(daily_date_range)
    @weekly_active_users_total = Log.date_range_active_users_total(weekly_date_range)

    @daily_booker_total = Log.booking_total_count(daily_date_range)
    @weekly_booker_total = Log.booking_total_count(weekly_date_range)

    booking_durations = Log.booking_duration(daily_date_range)
    @average_duration = Log.average_duration(booking_durations)
    @longest_duration = Log.longest_duration(booking_durations)
  end
end
