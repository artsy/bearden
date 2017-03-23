class ApplicationController < ActionController::Base
  http_basic_authenticate_with(
    name: Rails.application.secrets.user,
    password: Rails.application.secrets.password
  )
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  private

  def ssl_configured?
    !Rails.env.development?
  end
end
