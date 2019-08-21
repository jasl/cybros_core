# frozen_string_literal: true

module API
  class ApplicationController < ActionController::API
    before_action :authenticate_user!

    def user_info
      render json: { email: current_user.email }
    end
  end
end
