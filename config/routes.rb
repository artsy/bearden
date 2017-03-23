Rails.application.routes.draw do
  require 'sidekiq/web'
  # see config/initializers/sidekiq.rb for security details
  mount Sidekiq::Web, at: '/sidekiq'

  mount ActionCable.server => :cable

  resources :imports, only: [:new, :create, :show, :index]
  resources :tags, only: :index
end
