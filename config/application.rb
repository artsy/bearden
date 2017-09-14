require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bearden
  class Application < Rails::Application
    config.action_controller.forgery_protection_origin_check = true
    config.action_controller.per_form_csrf_tokens = true
    config.active_job.queue_adapter = :sidekiq
    config.active_record.belongs_to_required_by_default = true
    config.active_record.schema_format = :sql
    config.active_support.to_time_preserves_timezone = true
    config.ssl_options = { hsts: { subdomains: true } }

    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    # config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
    config.eager_load_paths += [Rails.root.join('lib')]
  end
end
