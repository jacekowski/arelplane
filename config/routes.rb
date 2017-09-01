Rails.application.routes.draw do
  root to: 'pages#index'

  resources :users, only: [:show]
  resources :flights, only: [:index, :create, :destroy]
  # resources :locations

  devise_for :users,
    controllers: {
      registrations: 'registrations'
    },
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    }
end
