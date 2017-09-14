class Api::V1::PingController < ApiController
  def show
    render json: { timestamp: Time.now.to_i }
  end
end
