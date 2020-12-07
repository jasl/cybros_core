# frozen_string_literal: true

module Admin::Users
  class InvitationsController < Admin::ApplicationController
    def new
      prepare_meta_tags title: t(".title")
      @user = User.new
    end

    def create
      @user = User.invite!(user_params, current_user)

      if @user
        redirect_to admin_user_url(@user), notice: t(".shared.notice.created")
      else
        prepare_meta_tags title: t("admin.users.invitations.new.title")
        render :new
      end
    end

    private

      def user_params
        params.fetch(:user, {}).permit(:email)
      end
  end
end
