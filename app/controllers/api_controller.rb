class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :ensure_jwt

  private

  def ensure_jwt
    render plain: 'Access Denied', status: :unauthorized unless token_match?
  end

  def token_match?
    auth_header = request.headers['HTTP_AUTHORIZATION']
    token = auth_header.split(' ').last
    secret = Rails.application.secrets.artsy_internal_secret
    payload = JWT.decode(token, secret).first
    validate_payload(payload)
  rescue JWT::DecodeError, NoMethodError
    return false
  end

  def validate_payload(payload)
    payload['roles'].split(',').include?('trusted')
  end
end
