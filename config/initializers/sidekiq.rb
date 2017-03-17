# from: https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
require 'sidekiq/web'

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    input_user = ::Digest::SHA256.hexdigest username
    actual_user = ::Digest::SHA256.hexdigest ENV['SIDEKIQ_USERNAME']

    input_pass = ::Digest::SHA256.hexdigest password
    actual_pass = ::Digest::SHA256.hexdigest ENV['SIDEKIQ_PASSWORD']

    ActiveSupport::SecurityUtils.secure_compare(input_user, actual_user) &
      ActiveSupport::SecurityUtils.secure_compare(input_pass, actual_pass)
  end
end
