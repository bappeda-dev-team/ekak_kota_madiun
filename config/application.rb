require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PrototypeKak
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.generators.stylesheets = false
    config.active_model.i18n_customize_full_message = true
    config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, DateTime, ActiveSupport::TimeWithZone,
                                                          ActiveSupport::TimeZone, ActiveSupport::HashWithIndifferentAccess]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    # "Jakarta" => "Asia/Jakarta"
    config.time_zone = 'Jakarta'
    config.active_job.queue_adapter = :sidekiq
    config.active_record.schema_format = :sql
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators.system_tests = nil
    config.generators do |g|
      g.test_framework(
        :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: true
      )
    end
  end
end
