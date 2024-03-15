class UsersController < ApplicationController

  def index
    @users = User.includes(:logs).all.sort_by{ |user| user.logs.last&.timestamp || Time.current }.reverse
  end

  def show
    @user = User.find(params[:id])
    @logs = @user.logs.order(timestamp: :desc)
  end

end
