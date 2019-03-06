# frozen_string_literal: true

module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    before_action :set_page_layout_data, if: -> { request.format.html? }

    protected

      def set_page_layout_data
        @_sidebar_name = "admin"
      end

      def require_admin!
        unless user_signed_in? && current_user.admin?
          redirect_back fallback_location: root_url
        end
      end
  end
end
