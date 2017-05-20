Rails.application.routes.draw do
  namespace :admin do
    resources :categories, except: :show
  end

  resources :updates, only: :create
  resources :dashboard, only: :index
  telegram_webhooks TelegramController
end
