# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :admins
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  
  resources :activities do
    resources :bookings, only: [:create, :destroy]
  end
  resources :bookings, only: [ :index ]
  resources :logs

  root 'activities#index'
end
