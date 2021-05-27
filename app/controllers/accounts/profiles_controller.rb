# frozen_string_literal: true

module Accounts
  class ProfilesController < Accounts::ApplicationController
    before_action :set_user

    def show
    end

    def update
      if @user.update_without_password(user_params)
        redirect_to after_update_url, notice: t("accounts.profiles.show.updated")
      else
        render :show
      end
    end

    private

      def set_user
        @user = current_user
      end

      def user_params
        params.require(:user).permit(:email)
      end

      def after_update_url
        account_profile_url
      end
  end
end
