Rails.application.routes.draw do
  root to: redirect('/imports')

  require 'sidekiq/web'
  # see config/initializers/sidekiq.rb for security details
  mount Sidekiq::Web, at: '/sidekiq'

  mount ActionCable.server => :cable

  resources :imports, only: [:new, :create, :show, :index]
  resources :sources, only: [:index, :new, :create]
  resources :tags, only: :index
end
