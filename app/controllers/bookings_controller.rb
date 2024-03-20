# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    ActiveRecord::Base.transaction do
      @activity = Activity.find(params[:activity_id])
      if has_space?(@activity) && open_for_booking?(@activity)
        @booking = @activity.bookings.new(booking_params.merge(user: current_user))
        raise ActiveRecord::Rollback, '請確實填寫資料' unless @booking.save

        current_user.logs.create!(type: 'submitted', booking: @booking, activity: @activity)
        # SummaryMailer.send_daily_summaries
        redirect_to @activity, notice: '報名成功'

      else
        redirect_to root_path, alert: '時間已經超過了'
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback => e
    # 有錯誤訊息就顯示
    redirect_to @activity, alert: e.message.presence || '無法完成報名'
  end

  def destroy
    @booking = current_user&.bookings&.find(params[:id])
    @booking.destroy
    current_user.logs.create!(type: 'cancel_booking', booking: @booking)
    redirect_to bookings_path, notice: '報名已經取消'
  end

  def index
    @bookings = current_user&.bookings
  end

  def show
    @booking = current_user&.bookings&.find(params[:id])
    current_user.logs.create!(type: 'browse_booked_show', booking: @booking)
  rescue ActiveRecord::RecordInvalid
    Rails.logger.error "browse booking show page log create failed, user id : #{current_user.id}"
  end

  private

  def booking_params
    params.require(:booking).permit(:booker_name, :booker_email, :activity_id).merge(user: current_user)
  end
end
