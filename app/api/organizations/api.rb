module Organizations
  class API < Grape::API
    version 'v1', using: :path
    format :json

    namespace :organizations do
      params do
        requires :term, type: String, desc: 'Term to match.'
        optional :size, type: Integer, desc: 'Maximum number of items to retrieve.', default: 5
        optional :page, type: Integer, desc: 'Page to retrieve.', default: 1
      end
      desc 'search organization names'
      get :search do
        Organization.estella_search(params)
      end

      desc 'auto-complete organization names'
      #params :match_params do
      params do
        requires :term, type: String, desc: 'Term to match.'
        optional :size, type: Integer, desc: 'Maximum number of items to retrieve.', default: 5
        optional :page, type: Integer, desc: 'Page to retrieve.', default: 1
      end
      get :suggest do
        Organization.__elasticsearch__.search(Search::OrganizationsQuery.new(params).query).records.to_a
      end
    end
  end
end
