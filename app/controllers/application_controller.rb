# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def has_space?(activity)
    activity.bookings.count < activity.max_participants
  end

  def open_for_booking?(activity)
    activity.start_time > Time.zone.now
  end

  private

  def not_found
    render file: Rails.public_path.join('404.html'),
           status: 404,
           layout: false
  end

  def user_not_authorized
    flash[:alert] = '你沒有權限'
    redirect_to root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
