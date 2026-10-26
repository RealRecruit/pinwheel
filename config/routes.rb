Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :settings, only: %i[ show update ]

  resources :accounts, only: :index do
    resources :projects, only: %i[ index show new create ] do
      resources :assignments, only: :create
      resources :comments, only: :create
      resource :archival, only: :create, module: :projects
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"

    namespace :dev do
      resources :push_deliveries, only: :index
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "accounts#index"
end
