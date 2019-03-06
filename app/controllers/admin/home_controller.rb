# frozen_string_literal: true

class Admin::HomeController < Admin::ApplicationController
  def index
    prepare_meta_tags title: t("admin.home.index.title")
  end
end
