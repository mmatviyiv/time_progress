Rails.application.routes.draw do
  root 'main#index'
  match :install, to: 'main#install', as: 'slack_oauth_install', via: [:get, :post]
  match :authorize, to: 'main#authorize', as: 'slack_oauth_authorize', via: [:get, :post]

  devise_for :users, skip: [:sessions, :registrations]

  resources :slack, only: [:create]
  resources :notifiers, except: [:show, :edit], path: 'settings'
end
