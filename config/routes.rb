Rails.application.routes.draw do
  namespace :admin do
    resources :categories, except: :show
  end

  resources :updates, only: :create
  resources :dashboard, only: :index

  namespace :api do
    namespace :v1 do
      resources :dashboard, only: :index
      resources :transactions, only: [:index, :create, :update]
    end
  end

  root to: 'dashboard#index'
  get "authorize", to: "sessions#index"
  telegram_webhook TelegramController
end
