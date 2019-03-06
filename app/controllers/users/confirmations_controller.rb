# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    layout "sign_in"

    # GET /resource/confirmation/new
    def new
      prepare_meta_tags title: t("users.confirmations.new.title")
      super
    end

    # POST /resource/confirmation
    def create
      prepare_meta_tags title: t("users.confirmations.new.title")
      super
    end

    # GET /resource/confirmation?confirmation_token=abcdef
    # def show
    #   super
    # end

    # protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    # def after_confirmation_path_for(resource_name, resource)
    #   super(resource_name, resource)
    # end
  end
end
