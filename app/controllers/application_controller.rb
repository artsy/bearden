class ApplicationController < ArtsyAuth::ApplicationController
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  def authorized_artsy_token?(token)
    secret = Rails.application.secrets.artsy_internal_secret
    decoded_token, _headers = JWT.decode(token, secret)
    decoded_token['roles'].include? 'admin'
  end

  private

  def ssl_configured?
    !Rails.env.development?
  end
end
