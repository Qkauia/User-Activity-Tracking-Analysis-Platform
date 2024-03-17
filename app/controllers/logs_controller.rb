# frozen_string_literal: true

class LogsController < ApplicationController
  # 整個 ApisController 關閉檢查
  # skip_before_action :verify_authenticity_token

  def create
    @activity = Activity.find(params[:activity_id])
    current_user.logs.create!(type: params[:type], activity: @activity)
    head :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
