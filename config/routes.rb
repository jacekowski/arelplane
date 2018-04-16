Rails.application.routes.draw do
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
        collection do
          get 'search', to: 'users#search'
        end
        resources :flights, only: :index
      end
      resources :flights, only: [:index, :show]
      resources :locations, only: :show do
        collection do
          get 'search', to: 'locations#search'
        end
      end
      resources :users, param: :username, only: :show
    end
  end

  resources :users, only: :show

  resources :flights, except: :show do
    collection do
      delete 'destroy_multiple'
      post 'search', to: 'flights#search'
      get 'search', to: 'flights#search'
    end
  end

  resources :waypoints, only: :destroy
  resources :user_followings, only: [:create, :destroy]

  # resources :locations

  devise_for :users,
    controllers: {
      registrations: 'registrations'
    },
    path: '',
    path_names: {
      edit: ':username/edit',
      sign_in: 'login',
      sign_out: 'logout'
    }
  resources :users, param: :username, path: '', only: :show, as: :username
  post 'users/search', to: 'users#search', as: 'user_search'

  get 'unsubscribe/:unsubscribe_token', to: 'users#unsubscribe', as: 'unsubscribe'

  # resources :aircrafts

end
