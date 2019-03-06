# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    layout "sign_in"

    # GET /resource/password/new
    def new
      prepare_meta_tags title: t("users.passwords.new.title")
      super
    end

    # POST /resource/password
    def create
      prepare_meta_tags title: t("users.passwords.new.title")
      super
    end

    # GET /resource/password/edit?reset_password_token=abcdef
    def edit
      prepare_meta_tags title: t("users.passwords.edit.title")
      super
    end

    # PUT /resource/password
    def update
      prepare_meta_tags title: t("users.passwords.edit.title")
      super
    end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
