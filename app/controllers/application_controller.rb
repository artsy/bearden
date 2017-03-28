class ApplicationController < ActionController::Base
  http_basic_authenticate_with(
    name: Rails.application.secrets.admin_username,
    password: Rails.application.secrets.admin_password
  )
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  private

  def ssl_configured?
    !Rails.env.development?
  end
end
