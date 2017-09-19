class Api::V1::SearchController < ApiController
  DEFAULT_SEARCH_SIZE = 20

  before_action :ensure_term

  expose(:organizations) { Organization.estella_search(estella_options) }

  private

  def estella_options
    size = params.fetch(:size, DEFAULT_SEARCH_SIZE)
    params.permit(:term).merge(size: size)
  end

  def ensure_term
    render plain: 'no term parameter', status: :bad_request unless estella_options.include?(:term)
  end
end
