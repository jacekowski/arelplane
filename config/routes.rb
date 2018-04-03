Rails.application.routes.draw do
  resources :aircrafts
  authenticated do
    root :to => 'users#home', as: :authenticated
  end
  root :to => 'pages#index'

  get 'upload_instructions', to: 'pages#upload_instructions'
  get 'unsubscribe_confirmation', to: 'pages#unsubscribe_confirmation'
  get 'privacy', to: 'pages#privacy_policy'

  namespace :api, constraints: {format: :json} do
    namespace :v1 do
      resources :users, only: [] do
        resources :flights, only: :index
      end
      resources :flights, only: [:index, :show]
      resources :locations, only: :show
      get 'identifier_search', to: 'locations#search_by_identifier'
      get 'user_search', to: 'users#search_by_username'
    end
  end

  resources :users, only: [:show]
  resources :flights, except: [:show]
  post 'flight_search', to: 'flights#search'
  get 'flight_search', to: 'flights#search'
  resources :waypoints, only: :destroy
  resources :user_followings, only: [:create, :destroy]

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
  resources :users, param: :username, path: '', only: [:show], as: :username
  post 'user_search', to: 'users#search'

  get 'unsubscribe/:unsubscribe_token', to: 'users#unsubscribe', as: 'unsubscribe'

end
