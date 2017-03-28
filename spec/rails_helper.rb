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
  end

  config.before(:each, type: :feature) do
    user = Rails.application.secrets.user
    password = Rails.application.secrets.password
    page.driver.browser.basic_authorize(user, password)
  end

  config.around(:each, type: :feature) do |example|
    original_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :inline
    example.run
    ActiveJob::Base.queue_adapter = original_adapter
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
