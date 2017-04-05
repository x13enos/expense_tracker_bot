Rails.application.routes.draw do
  resources :updates, only: :create
end
