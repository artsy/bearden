Rails.application.routes.draw do
  root to: redirect('/imports')

  # GraphQL
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/api/graphql'
  end

  post '/api/graphql', to: 'graphql#execute'

  require 'sidekiq/web'
  # see config/initializers/sidekiq.rb for security details
  mount Sidekiq::Web, at: '/sidekiq'

  mount ActionCable.server => :cable

  mount ArtsyAuth::Engine => '/'

  resources :imports, only: %i[create index new show]
  resources :sources, only: %i[create edit index new update]
  resources :syncs, only: :index
  resources :tags, only: :index
  resources :types, only: :index
end
