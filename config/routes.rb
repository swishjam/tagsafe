Rails.application.routes.draw do
  root 'tags#index'
  require 'resque/server'
  mount Resque::Server.new, at: '/queue'

  get '/login' => 'sessions#new', as: :new_session
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout

  resources :registrations, only: [:new, :create]
  get '/register' => 'registrations#new'

  get '/install' => 'installation#install', as: :install

  resources :tags do
    resources :tag_versions, only: [:index, :show] do
      member do
        get :diff
      end
    end
  end
end
