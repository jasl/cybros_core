# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    layout "sign_in"

    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    def new
      prepare_meta_tags title: t("users.sessions.new.title")
      super
    end

    # POST /resource/sign_in
    def create
      prepare_meta_tags title: t("users.sessions.new.title")
      super
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
