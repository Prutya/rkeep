Rails.application.routes.draw do
  authenticated :user do
    root 'bills#index'
  end
  root 'home#index'

  resources :bills, only: [:index, :new, :create]

  devise_for :users, path: '', path_names: { sign_in: 'sign-in' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
