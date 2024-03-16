# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render file: Rails.public_path.join('404.html'),
           status: 404,
           layout: false
  end

  private

  def user_not_authorized
    flash[:alert] = "你沒有權限"
    redirect_to root_path
  end

end
