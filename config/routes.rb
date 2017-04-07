Rails.application.routes.draw do
  resources :updates, only: :create

  telegram_webhooks TelegramController
end
