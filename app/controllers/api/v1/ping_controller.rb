class Api::V1::PingController < ApiController
  skip_before_action :ensure_jwt

  def show
    render json: { timestamp: Time.now.to_i }
  end
end
