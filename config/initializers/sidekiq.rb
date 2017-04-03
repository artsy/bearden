# from: https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
require 'sidekiq/web'

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    input_user = ::Digest::SHA256.hexdigest username
    secret_user = Rails.application.secrets.sidekiq_username
    actual_user = ::Digest::SHA256.hexdigest secret_user

    input_pass = ::Digest::SHA256.hexdigest password
    secret_pass = Rails.application.secrets.sidekiq_password
    actual_pass = ::Digest::SHA256.hexdigest secret_pass

    ActiveSupport::SecurityUtils.secure_compare(input_user, actual_user) &
      ActiveSupport::SecurityUtils.secure_compare(input_pass, actual_pass)
  end
end
