# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      super do |user|
        user.logs.create!(type: 'login')
      rescue ActiveRecord::RecordInvalid
        Rails.logger.error "Sign in log create failed, user id : #{user.id}"
      end
    end

    # DELETE /resource/sign_out
    def destroy
      user = current_user
      super
      Log.create!(user:, type: 'logout') if user
    rescue ActiveRecord::RecordInvalid
      Rails.logger.error "Sign out log create failed, user id : #{user.id}"
    end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
