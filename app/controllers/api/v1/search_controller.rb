class Api::V1::SearchController < ApiController
  before_action :ensure_term

  expose(:organizations) { Organization.estella_search(estella_options) }

  private

  def estella_options
    params.permit(:term)
  end

  def ensure_term
    render plain: 'no term parameter', status: :bad_request unless estella_options.include?(:term)
  end
end
