# frozen_string_literal: true

module Accounts
  class JwtsController < Accounts::ApplicationController
    before_action :set_user

    def index
      @whitelisted_jwts = @user.whitelisted_jwts
    end

    def update
      if @user.update(jwts_params)
        redirect_to account_jwts_path, notice: t("accounts.jwts.index.updated")
      else
        render :index
      end
    end

    def destroy
      @jwt = @user.whitelisted_jwts.find(params[:id])
      @jwt.destroy!
      redirect_to account_jwts_path, notice: t("accounts.jwts.index.deleted")
    end

    private

      def set_user
        @user = current_user
      end

      def jwts_params
        params.require(:user).permit(:email, :full_name)
      end
  end
end
