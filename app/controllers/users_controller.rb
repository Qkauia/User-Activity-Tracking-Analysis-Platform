class UsersController < ApplicationController

  def index
    @users = User.includes(:logs).all.sort_by{ |user| user.logs.last&.created_at || Time.current }.reverse
  end

  def show
    @user = User.find(params[:id])
    @logs = @user.logs.order(created_at: :desc)
    authorize @user
    @daily_active_users_total =  Log.date_range_active_users_total(1)
    @weekly_active_users_total =  Log.date_range_active_users_total(7)
  end

end
