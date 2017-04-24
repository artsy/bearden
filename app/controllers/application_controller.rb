class ApplicationController < ArtsyAuth::ApplicationController
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?
  helper_method :admin?

  ADMIN_USERS = Rails.application.secrets.admin_users
  ALLOWED_GRAVITY_ROLES = ['admin'].freeze

  def authorized_artsy_token?(token)
    @user = user(token)
    success_or_die
  end

  def user(token)
    secret = Rails.application.secrets.artsy_internal_secret
    decoded_token, _headers = JWT.decode(token, secret)

    { uid: decoded_token['sub'],
      roles: decoded_token['roles'].split(',') }
  end

  def admin?
    ADMIN_USERS.member? @user[:uid]
  end

  private

  def ssl_configured?
    !Rails.env.development?
  end

  def role_permitted?
    @user[:roles].any? { |role| ALLOWED_GRAVITY_ROLES.member? role }
  end

  def success_or_die
    role_permitted? || render(plain: '404 Not Found', status: 404)
  end
end
