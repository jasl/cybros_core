# frozen_string_literal: true

class ErrorsController < ApplicationController
  layout "sign_in"

  before_action :set_page_meta_tags

  def unauthorized
    render status: :unauthorized
  end

  def forbidden
    render status: :forbidden
  end

  def not_found
    render status: :not_found
  end

  protected

    def set_page_meta_tags
      prepare_meta_tags title: t("errors.#{action_name}.title")
    end
end
