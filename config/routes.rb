Rails.application.routes.draw do
  resources :categories
  root "events#index" # Ana sayfa

  namespace :admin do
  resources :categories, except: [:show]
end

  resources :events do
    resources :registrations, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  get "etkinliklerim", to: "users#events", as: :my_events
  
  get "kayit", to: "users#new", as: :signup
  post "kayit", to: "users#create"

  
  get "giris", to: "sessions#new", as: :login
  post "giris", to: "sessions#create"
  delete "cikis", to: "sessions#destroy", as: :logout
end