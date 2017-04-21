class ApplicationController < ArtsyAuth::ApplicationController
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?
  helper_method :admin?

  ADMIN_ROLE = 'marketing_db_admin'.freeze
  ALLOWED_GRAVITY_ROLES = ['admin', ADMIN_ROLE].freeze

  def authorized_artsy_token?(token)
    @roles = user_roles(token)
    success_or_die
  end

  def user_roles(token)
    secret = Rails.application.secrets.artsy_internal_secret
    decoded_token, _headers = JWT.decode(token, secret)
    decoded_token['roles'].split(',')
  end

  def admin?
    @roles.include? ADMIN_ROLE
  end

  private

  def ssl_configured?
    !Rails.env.development?
  end

  def role_permitted?
    @roles.any? { |role| ALLOWED_GRAVITY_ROLES.member? role }
  end

  def success_or_die
    role_permitted? || render(plain: '404 Not Found', status: 404)
  end
end
