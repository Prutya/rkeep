Rails.application.routes.draw do
  resources :user_shifts, only: []
  resources :shifts, only: []
  resources :bills, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      delete 'cancel'
    end

    resources :items, only: [:new, :create, :destroy], controller: :bill_items
  end

  resources :spendings

  authenticated :user do
    root 'bills#index'
  end
  root 'home#index'

  devise_for :users, path: '', path_names: { sign_in: 'sign-in' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
