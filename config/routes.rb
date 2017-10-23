Rails.application.routes.draw do
  get 'home/index'

  namespace :customers do
    get :index
    get :new
    get 'show/:id', action: :show, as: :show
    post :create
  end

  devise_for :users, :controllers => { registrations: 'registrations' }
  root to: 'home#index'
end
