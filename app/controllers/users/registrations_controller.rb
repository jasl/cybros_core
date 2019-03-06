# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout "sign_in", only: [:new, :create]

    before_action :configure_sign_up_params, only: [:create]

    # GET /resource/sign_up
    def new
      prepare_meta_tags title: t("users.registrations.new.title")
      super
    end

    # POST /resource
    def create
      prepare_meta_tags title: t("users.registrations.new.title")
      super
    end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

      # If you have extra params to permit, append them to the sanitizer.
      def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up) do |user_params|
          user_params.permit(:email, :full_name, :password, :password_confirmation)
        end
      end

      # The path used after sign up.
      def after_sign_up_path_for(resource)
        super(resource)
      end

      # The path used after sign up for inactive accounts.
      def after_inactive_sign_up_path_for(resource)
        new_session_path(resource_name)
      end
  end
end
