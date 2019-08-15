# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_signed_out_user, if: -> { request.format.json? }
    respond_to :json, if: -> { request.format.json? }
    before_action -> { prepare_meta_tags title: t("users.sessions.new.title") }, if: -> { request.format.html? }
    layout "sign_in"

    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    def new
      super
    end

    # POST /resource/sign_in
    def create
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
