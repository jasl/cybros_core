# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Require monkey patches
Dir[Pathname.new(File.dirname(__FILE__)).realpath.parent.join("lib", "monkey_patches", "*.rb")].map do |file|
  require file
end

module CybrosCore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework nil
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/overrides/**/*_override*.rb").each do |c|
        require_dependency(c)
      end
    end
    Rails.autoloaders.main.ignore("#{Rails.root}/app/overrides")

    # Read ActionMailer config from config/mailer.yml
    initializer "action_mailer.set_configs.set_yaml_configs", before: "action_mailer.set_configs" do |app|
      next unless File.exist?(Rails.root.join("config", "mailer.yml"))

      configure = app.config_for("mailer").deep_symbolize_keys
      configure.each do |key, value|
        setter = "#{key}="
        unless app.config.action_mailer.respond_to? setter
          raise "Can't set option `#{key}` to ActionMailer, make sure that options in config/mailer.yml are valid."
        end

        app.config.action_mailer.send(setter, value)
      end
    end

    # Separate ActiveStorage key base
    # initializer "app.active_storage.verifier", after: "active_storage.verifier" do
    #   config.after_initialize do |app|
    #     storage_key_base =
    #       if Rails.env.development? || Rails.env.test?
    #         app.secrets.secret_key_base
    #       else
    #         validate_secret_key_base(
    #           ENV["STORAGE_KEY_BASE"] || app.credentials.storage_key_base || app.secrets.storage_key_base
    #         )
    #       end
    #     key_generator = ActiveSupport::KeyGenerator.new(storage_key_base, iterations: 1000)
    #     secret = key_generator.generate_key("ActiveStorage")
    #     ActiveStorage.verifier = ActiveSupport::MessageVerifier.new(secret)
    #   end
    # end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # http://lulalala.logdown.com/posts/5835445-rails-many-default-url-options
    # if Settings.url_options&.respond_to?(:to_h)
    #   Rails.application.routes.default_url_options = Settings.url_options.to_h
    #   config.default_url_options = Settings.url_options.to_h
    #   config.action_controller.default_url_options = Settings.url_options.to_h
    #   config.action_mailer.default_url_options = Settings.url_options.to_h
    # end

    # config.time_zone = "Asia/Shanghai"
    # config.i18n.default_locale = "zh-CN"
  end
end
