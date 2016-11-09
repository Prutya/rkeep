Rails.application.routes.draw do
  authenticated :user do
    root 'bills#index'
  end
  root 'home#index'

  resources :bills, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :items, only: [:new, :create, :destroy], controller: :bill_items
  end

  devise_for :users, path: '', path_names: { sign_in: 'sign-in' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
