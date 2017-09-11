Rails.application.routes.draw do
  root to: 'pages#index'

  namespace :api, constraints: {format: :json} do
    namespace :v1 do
      resources :users, only: [] do
        resources :flights, only: :index
      end
      resources :flights, only: :index
    end
  end

  resources :users, only: [:show]
  resources :flights, only: [:index, :create, :destroy]
  resources :locations

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
