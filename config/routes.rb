Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login', sign_out: 'logout'
  }
  resources :users, only: [:create, :show]
  root to: 'pages#index'
  resources :flights
  # resources :locations
end
