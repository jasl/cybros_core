# frozen_string_literal: true

module ActionMailer
  class Railtie < Rails::Railtie
    initializer "action_mailer.set_configs.set_yaml_configs", before: "action_mailer.set_configs" do |app|
      configure = app.config_for("mailer").deep_symbolize_keys
      configure.each do |key, value|
        setter = "#{key}="
        unless app.config.action_mailer.respond_to? setter
          raise "Can't set option `#{key}` to ActionMailer, make sure that options in config/mailer.yml are valid."
        end

        app.config.action_mailer.send(setter, value)
      end
    end
  end
end
