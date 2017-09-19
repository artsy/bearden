class AdminController < ApplicationController
  protect_from_forgery with: :exception

  include ArtsyAuth::Authenticated

  ADMIN_USERS = Rails.application.secrets.admin_users
  ALLOWED_GRAVITY_ROLES = ['admin'].freeze

  def authorized_artsy_token?(token)
    @user = decode_user(token)
    role_permitted?
  end

  def admin?
    ADMIN_USERS.member? @user[:uid]
  end
  helper_method :admin?

  private

  def decode_user(token)
    secret = Rails.application.secrets.artsy_internal_secret
    decoded_token, _headers = JWT.decode(token, secret)

    {
      uid: decoded_token['sub'],
      roles: decoded_token['roles'].split(',')
    }
  end

  def role_permitted?
    @user[:roles].any? { |role| ALLOWED_GRAVITY_ROLES.member? role }
  end
end
