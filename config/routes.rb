# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  resources :activities
  resources :bookings
  resources :logs

  root 'activities#index'
end
