Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :create
  root to: 'pages#index'
  resources :flights
  # resources :locations
end
