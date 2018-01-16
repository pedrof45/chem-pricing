require_relative 'boot'
require 'rails/all'
Bundler.require(*Rails.groups)

module ChemPricing
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose: ['X-Page', 'X-PageTotal'],
          methods: [:get, :post, :delete, :put, :options]
      end
    end
    config.i18n.default_locale = 'pt-BR'
    config.i18n.fallbacks = [:es, :en]

    config.assets.paths << Rails.root.join('node_modules')
    config.load_defaults 5.1
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :utc
    config.action_controller.asset_host = ENV['APPLICATION_HOST']
    config.action_mailer.default_url_options = { host: ENV['APPLICATION_HOST'] }
    config.action_mailer.asset_host = ENV['MAILER_HOST'] || ENV['APPLICATION_HOST']

    config.action_mailer.delivery_method = :sendgrid
    config.action_mailer.sendgrid_settings = {
        api_key: ENV['SENDGRID_API_KEY']
    }
    # config.action_mailer.smtp_settings = {
    #     address: ENV["SMTP_ADDRESS"],
    #     authentication: :plain,
    #     domain: ENV["SMTP_DOMAIN"],
    #     enable_starttls_auto: true,
    #     password: ENV["SMTP_PASSWORD"],
    #     port: ENV["SMTP_PORT"],
    #     user_name: ENV["SMTP_USERNAME"]
    # }
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
  end
end
