Rails.application.routes.draw do
  root to: 'pages#index'
  resources :flights
  resources :locations
end
