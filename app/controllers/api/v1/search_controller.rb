class Api::V1::SearchController < ApiController
  before_action :ensure_jwt
  before_action :ensure_term

  expose(:organizations) { Organization.estella_search(estella_options) }

  private

  def estella_options
    params.permit(:term)
  end

  def ensure_term
    render plain: 'no term parameter', status: :bad_request unless estella_options.include?(:term)
  end

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
