require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module DeadchanNet
  class Application < Rails::Application
    config.time_zone = 'Europe/Moscow'
    config.i18n.default_locale = :ru
    config.quiet_assets = true

    config.autoload_paths += ["#{config.root}/lib/middlewares"]
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec, fixture: false, view: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.view_specs      false
      g.helper_specs    false
    end

    config.cache_store = :redis_store, {
      host: "127.0.0.1",
      port: 6379,
      db: 0,
      namespace: "deadchan.net:cache",
      expires_in: 7*24*60*60
    }

    def application_config
      @application_config ||= YAML.load_file(Rails.root.join('config', 'app.yml'))[Rails.env]
    end

    # Middlewares
    config.middleware.use 'SessionIpMiddleware'
    config.middleware.use 'PanicModeMiddleware'
    config.middleware.use 'FullBanMiddleware'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
