# frozen_string_literal: true

module Accounts
  class JwtsController < Accounts::ApplicationController
    before_action :set_user

    def index
      @whitelisted_jwts = @user.whitelisted_jwts
    end

    def create
      exp_seconds = params[:exp_hours].to_i.hours
      user_encoder = Warden::JWTAuth::UserEncoder.new
      payload = user_encoder.helper.payload_for_user(current_user, "user")
      payload["exp"] = Time.now.to_i + exp_seconds.to_i
      payload["aud"] = params[:aud]
      jwt = Warden::JWTAuth::TokenEncoder.new.call(payload)
      Rails.logger.debug "jwt: #{jwt}"
      if @user.whitelisted_jwts.create(jti: payload["jti"], aud: payload["aud"], exp: Time.at(payload["exp"]))
        redirect_to account_jwts_path, alert: t(".created", jwt: jwt)
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
  end
end
