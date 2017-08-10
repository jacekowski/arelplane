Rails.application.routes.draw do
  resources :users, only: :create
  root to: 'pages#index'
  # resources :flights
  # resources :locations
end
