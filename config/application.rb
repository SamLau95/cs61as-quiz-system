require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Cs61asQuizzes
  class Application < Rails::Application
    # Stops rails from generating the assets and specs
    config.generators do |g|
      g.assets = false
      g.helper = false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_record.schema_format = :ruby
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = false

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]

    # For mailer

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default :charset => "utf-8"

    config.action_mailer.smtp_settings = {
       address:              "smtp.gmail.com",
       port:                 587,
       domain:               ENV["GMAIL_DOMAIN"],
       user_name:            ENV["GMAIL_USERNAME"],
       password:             ENV["GMAIL_PASSWORD"],
       authentication:       :plain,
       enable_starttls_auto: true
    }
  end
end
