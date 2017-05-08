ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is production!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.after(:each) do
    adapter_class = ActiveJob::Base.queue_adapter.class
    if adapter_class == ActiveJob::QueueAdapters::TestAdapter
      ActiveJob::Base.queue_adapter.enqueued_jobs = []
      ActiveJob::Base.queue_adapter.performed_jobs = []
    end
  end

  config.before do
    PaperTrail.whodunnit = 'Test User'

    CarrierWave.configure do |c|
      c.storage = :file
      c.enable_processing = false
    end
  end

  config.before(:each, type: :feature) do
    allow_any_instance_of(ApplicationController).to(
      receive(:require_artsy_authentication)
    )
    allow(SlackBot).to receive(:post)
    allow(S3CsvExport).to receive(:create)
  end

  config.around(:each, type: :feature) do |example|
    original_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :inline
    example.run
    ActiveJob::Base.queue_adapter = original_adapter
    carrier_wave_dir = File.join S3Uploader.root.call, S3Uploader.store_dir
    FileUtils.rm_rf(carrier_wave_dir)
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
