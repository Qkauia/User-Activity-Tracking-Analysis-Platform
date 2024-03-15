# frozen_string_literal: true

class ActivitiesController < ApplicationController
  before_action :find_activity, only: %i[show edit update destroy]

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to activities_path, notice: '活動建立成功'
    else
      render :new
    end
  end

  def show
    @booking = Booking.new
    current_user&.logs&.create!(log_type: 'browse_activity_show', timestamp: Time.current, activity: @activity)
    rescue ActiveRecord::RecordInvalid
    Rails.logger.error "browse activity booking page log create failed, user id : #{current_user.id}"
  end

  def edit; end

  def update
    if @activity.update(activity_params)
      redirect_to activity_path(@activity), notice: '活動更新成功'
    else
      render :edit
    end
  end

  def destroy
    @activity.destroy
    redirect_to activities_path, notice: '活動已經刪除'
  end

  def index
    @activities = Activity.all
    current_user&.logs&.create!(log_type: 'browse_root', timestamp: Time.current)
    rescue ActiveRecord::RecordInvalid
    Rails.logger.error "browse root page log create failed, user id : #{current_user.id}"
  end

  private

  def find_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:title, :description, :start_time, :end_time, :location, :organizer, :status,
                                     :max_participants).merge(user: current_user)
  end
end
