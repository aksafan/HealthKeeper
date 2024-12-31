# frozen_string_literal: true

Rails.application.routes.draw do
  resources :biomarkers do
    resources :reference_ranges, only: %i[show new create edit update destroy]
  end
  resources :reference_ranges

  resources :measurements
  resources :lab_tests
  resources :health_records
  namespace :admin do
    resources :users, only: %i[index show edit update destroy] do
      member do
        get :edit_roles
        post :update_roles
        get :edit_assigned_users
        post :update_assigned_users
      end
    end
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
end
