Rails.application.routes.draw do
  root 'books#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :books
end
