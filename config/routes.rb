Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :bills, only: [:index, :show, :update] do
        resources :items, only: [:create, :destroy], controller: :bill_items
      end
      resources :goods, only: [:index]
    end
  end

  resources :shifts, only: [:index, :show, :create, :destroy] do
    resources :users, only: [:index, :new, :create, :destroy], controller: :user_shifts
    resources :bills, only: [:show, :new, :create, :edit, :update, :destroy] do
      member do
        delete 'cancel'
      end

      resources :items, only: [:new, :create, :destroy], controller: :bill_items
    end
    resources :spendings, only: [:index, :new, :create, :destroy]
  end

  authenticated :user do
    root 'shifts#index'
  end
  root 'home#index'

  devise_for :users, path: '', path_names: { sign_in: 'sign-in' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
