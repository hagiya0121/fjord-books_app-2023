Rails.application.routes.draw do
  root 'books#index'
  resources :users, only: [:index, :show]
  resources :books
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
end
