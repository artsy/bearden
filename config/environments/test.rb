Rails.application.configure do
  config.action_controller.allow_forgery_protection = false
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_caching = false
  # allow env to override adapter - makes testing rake tasks easier
  config.active_job.queue_adapter = ENV['TEST_JOB_ADAPTER']&.to_sym || :test
  config.active_record.dump_schema_after_migration = false
  config.active_support.deprecation = :stderr
  config.cache_classes = true
  config.consider_all_requests_local = true
  config.eager_load = false
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # there's gotta be a cuter way to do this...
  Rails.application.routes.default_url_options[:host] = 'localhost:5000'
end
