class BookingsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    activity = Activity.find(params[:activity_id])
    @booking = activity.bookings.new(booking_params)
    if @booking.save
      redirect_to root_path, notice: '參加成功'
      # SummaryMailer.send_daily_summary
      # SummaryMailer.send_weekly_summary
    else
      redirect_to activity_path(activity) , alert: '請確實填寫資料'
    end
  end

  def destroy
    @booking = current_user&.bookings.find(params[:id])
    @booking.destroy
    redirect_to root_path, notice: '報名已經取消'
  end

  def index
    @bookings = current_user&.bookings
  end

  private

  def booking_params
    params.require(:booking).permit(:booker_name, :booker_email, :activity_id).merge(user: current_user)
  end

end
