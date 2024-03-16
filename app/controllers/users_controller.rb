class UsersController < ApplicationController

  def index
    @users = User.includes(:logs).all.sort_by{ |user| user.logs.last&.created_at || Time.current }.reverse
  end

  def show
    @user = User.includes(:logs).find(params[:id])
    @logs = @user.logs.order(created_at: :desc)
    authorize @user
    
    daily_start_date = Time.zone.today.beginning_of_day
    weekly_start_date = Date.today.beginning_of_week(:sunday)

    @daily_active_users_total =  Log.date_range_active_users_total(daily_start_date)
    @weekly_active_users_total =  Log.date_range_active_users_total(weekly_start_date)

    @daily_booker_total = Log.booking_total_count(daily_start_date)
    @weekly_booker_total = Log.booking_total_count(weekly_start_date)

    booking_durations = Log.booking_duration(daily_start_date)
    @average_duration = Log.average_duration(booking_durations)
    @longest_duration = Log.longest_duration(booking_durations)

  end

end
