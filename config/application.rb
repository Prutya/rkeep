require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rkeep
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Configure Rails time zone
    config.time_zone = ENV.fetch('RKEEP_TIME_ZONE') { 'UTC' }
    config.telegram_key = ENV['TELEGRAM_BOT_KEY']
    config.telegram_channel_id = ENV['TELEGRAM_CHANNEL_ID']
  end
end
