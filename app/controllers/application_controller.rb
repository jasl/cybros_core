# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :prepare_meta_tags, if: -> { request.format.html? }

  include StoreLocation

  protected

    def prepare_meta_tags(options = {})
      site_name   = Settings.seo_meta.name
      title       = nil
      description = Settings.seo_meta.description
      current_url = request.url

      # Let's prepare a nice set of defaults
      defaults = {
        site:        site_name,
        title:       title,
        description: description,
        keywords:    Settings.seo_meta.keywords,
        og: {
          url: current_url,
          site_name: site_name,
          title: title,
          description: description,
          type: "website"
        }
      }

      options.reverse_merge!(defaults)

      set_meta_tags options
    end

    def forbidden!(redirect_url: nil)
      if redirect_url.present?
        store_location redirect_url
      else
        store_location request.referrer
      end

      redirect_to forbidden_url
    end

    %w(forbidden unauthorized not_found).each do |s|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{s}!(redirect_url: nil)
        if redirect_url.present?
          store_location redirect_url
        else
          store_location request.referrer
        end

        redirect_to #{s}_url
      end
      RUBY_EVAL
    end
end
