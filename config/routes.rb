Rails.application.routes.draw do
  root to: redirect('/imports')

  require 'sidekiq/web'
  # see config/initializers/sidekiq.rb for security details
  mount Sidekiq::Web, at: '/sidekiq'

  mount ActionCable.server => :cable

  mount ArtsyAuth::Engine => '/'

  resources :imports, only: %i(create index new show)
  resources :sources, only: %i(create index new)
  resources :tags, only: :index
end
