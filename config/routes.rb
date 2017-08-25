Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login', sign_out: 'logout'
  }

  # authenticated :user do
  #   root 'users#show', as: :authenticated_root
  # end

  root to: 'pages#index'

  resources :users, only: [:create, :show]
  resources :flights, only: [:index, :show, :create, :destroy]
  # resources :locations
end
