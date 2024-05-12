Rails.application.routes.draw do
  root 'books#index'
  resources :books
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:index, :show]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
