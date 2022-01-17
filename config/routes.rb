# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'users'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :products do
        get :buy, on: :collection
      end
      resources :users, except: [:create, :edit] do
        put :deposit
        put :reset_deposit
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
