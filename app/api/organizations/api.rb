module Organizations
  class API < Grape::API
    version 'v1', using: :path
    format :json

    include Authentication::Helpers

    namespace :organizations do
      desc 'auto-complete organization names'
      params do
        requires :term, type: String, desc: 'Term to match.'
        optional :size, type: Integer, desc: 'Maximum number of items to retrieve.', default: 5
        optional :page, type: Integer, desc: 'Page to retrieve.', default: 1
      end
      get :search do
        params[:from] = (params[:page] - 1) * params[:size]
        Organization.estella_search(params)
      end
    end
  end
end
