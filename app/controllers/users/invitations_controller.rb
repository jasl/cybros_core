# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    layout "sign_in"

    def edit
      prepare_meta_tags title: t("users.invitations.edit.title")
      super
    end

    def update
      super
    end

    protected

      def after_accept_path_for(_resource)
        root_path
      end
  end
end
