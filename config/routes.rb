Rails.application.routes.draw do
  get "ratings/create"
  get "ratings/update"
  resources :categories
  root "events#index"
  resource :password, only: [:edit, :update]

  namespace :admin do
  resources :categories, except: [:show]
end

  resources :events do
    resources :ratings, only: [:create, :update]
    resources :registrations, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    resource :password, only: [:edit, :update]
  end

  get "etkinliklerim", to: "users#events", as: :my_events
  
  get "kayit", to: "users#new", as: :signup
  post "kayit", to: "users#create"

  
  get "giris", to: "sessions#new", as: :login
  post "giris", to: "sessions#create"
  delete "cikis", to: "sessions#destroy", as: :logout

  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end