Rails.application.routes.draw do
  root to: redirect('/imports')

  scope :v1, module: 'api/v1' do
    get :ping, to: 'ping#show'
  end

  require 'sidekiq/web'
  # see config/initializers/sidekiq.rb for security details
  mount Sidekiq::Web, at: '/sidekiq'

  mount ActionCable.server => :cable

  mount ArtsyAuth::Engine => '/'

  mount Bearden::API => '/api'

  resources :imports, only: %i[create index new show]
  resources :sources, only: %i[create edit index new update]
  resources :syncs, only: :index
  resources :tags, only: :index
  resources :types, only: :index
end
