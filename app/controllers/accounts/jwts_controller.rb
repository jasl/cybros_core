# frozen_string_literal: true

module Accounts
  class JwtsController < Accounts::ApplicationController
    before_action :set_user

    def index
      @whitelisted_jwts = @user.whitelisted_jwts
    end

    def create
      if @user.update(jwts_params)
        redirect_to account_jwts_path, notice: t(".created")
      else
        render :index
      end
    end

    def destroy
      @jwt = @user.whitelisted_jwts.find(params[:id])
      @jwt.destroy!
      redirect_to account_jwts_path, notice: t(".deleted")
    end

    def clean_expired_jwts
      @user.whitelisted_jwts.where("exp < ?", Time.now).each do |jwt|
        jwt.destroy
      end
      redirect_to account_jwts_path, notice: t(".done")
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
