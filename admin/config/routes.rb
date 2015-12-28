Admin::Engine.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users
  root to: "application#welcome"
end