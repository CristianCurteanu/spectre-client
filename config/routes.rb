# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'

  namespace :customers do
    get :index
    get :new
    get 'show/:id', action: :show, as: :show
    post :create
    get 'delete/:id', action: :destroy, as: :delete
  end

  namespace :logins do
    get :index
    get :new
    get 'show/:id', action: :show, as: :show
    post :create
    put 'refresh/:id', action: :refresh, as: :refresh
    get 'reconnect/:id', action: :reconnect, as: :reconnect
    post :update, action: :submit_reconnect, as: :update
    get 'delete/:id', action: :destroy, as: :destroy
  end

  namespace :accounts do
    get 'index/:login_id', action: :index, as: :index
    get 'show/:account_id', action: :show, as: :show
  end

  namespace :transactions do
    get :index
  end

  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'home#index'
end
