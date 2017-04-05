class ApplicationController < ArtsyAuth::ApplicationController
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  ALLOWED_ROLES = ['admin'].freeze

  def authorized_artsy_token?(token)
    roles = user_roles(token)
    success_or_die(roles)
  end

  def user_roles(token)
    secret = Rails.application.secrets.artsy_internal_secret
    decoded_token, _headers = JWT.decode(token, secret)
    decoded_token['roles'].split(',')
  end

  private

  def ssl_configured?
    !Rails.env.development?
  end

  def role_permitted?(roles)
    roles.any? { |role| ALLOWED_ROLES.member? role }
  end

  def success_or_die(roles)
    role_permitted?(roles) || render(plain: '404 Not Found', status: 404)
  end
end
