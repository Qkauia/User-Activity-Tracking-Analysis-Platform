# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'

  devise_for :admins
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations',
               passwords: 'users/passwords'
             }

  # Admin constraint for Sidekiq Web UI
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users, only: %i[index show]

  resources :activities do
    resources :bookings, only: %i[create destroy]
  end
  resources :bookings, only: %i[index show]

  post '/logs/create', to: 'logs#create'
  root 'activities#index'
end
