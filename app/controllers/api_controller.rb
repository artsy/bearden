class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :ensure_jwt

  private

  def ensure_jwt
    render plain: 'auth is wrong', status: :unauthorized unless token_match?
  end

  def token_match?
    auth_header = request.headers['HTTP_AUTHORIZATION']
    return unless auth_header
    token = auth_header.split(' ').last
    secret = Rails.application.secrets.artsy_internal_secret
    JWT.decode(token, secret)
  rescue JWT::DecodeError
    return false
  end
end
