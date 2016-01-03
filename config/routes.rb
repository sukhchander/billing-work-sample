Rails.application.routes.draw do

  mount Admin::Engine, at: "admin"

  namespace :api, defaults: { format: :json } do
    namespace :v1, version: :v1, module: :v1 do

      scope :billing do
        put :sku, to: 'products#update'
        put :billable, to: 'orders#update'
        delete :billable, to: 'orders#destroy'
      end

      scope :data do
        get '/chart/:type/(:id)', to: 'data#show', as: :chart_type
      end

    end
  end

  get '/dashboard', to: 'dashboard#index'

  #resources :users

  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations, :unlocks]

  devise_scope :user do

    authenticated :user do
      root to: 'dashboard#index'

      get 'dashboard/:type', to: 'dashboard#show', as: :dashboard_type
    end

    unauthenticated :user do
      root to: 'devise/sessions#new', as: 'new_user_session'
    end

    post '/login', to: 'devise/sessions#create', as: 'user_session'
    get '/logout', to: 'devise/sessions#destroy', as: 'destroy_user_session'

    get '/join', to: 'devise/registrations#new', as: 'new_user_registration'
    post '/join', to: 'devise/registrations#create', as: 'user_registration'

    scope '/account' do

      get '/verification', to: 'devise/confirmations#verification_sent', as: 'user_verification_sent'
      get '/confirm', to: 'devise/confirmations#show', as: 'user_confirmation'
      get '/confirm/resend', to: 'devise/confirmations#new', as: 'new_user_confirmation'
      post '/confirm', to: 'devise/confirmations#create'

      get '/reset-password', to: 'devise/passwords#new', as: 'new_user_password'
      get '/reset-password/change', to: 'devise/passwords#edit', as: 'edit_user_password'
      put  '/reset-password', to: 'devise/passwords#update', as: 'user_password'
      post '/reset-password', to: 'devise/passwords#create'

      post '/unlock', to: 'devise/unlocks#create', as: 'user_unlock'
      get '/unlock/new', to: 'devise/unlocks#new', as: 'new_user_unlock'
      get '/unlock', to: 'devise/unlocks#show'

      get '/cancel', to: 'devise/registrations#cancel', as: 'cancel_user_registration'
      get '/settings', to: 'devise/registrations#edit', as: 'edit_user_registration'
      put '/settings', to: 'devise/registrations#update'

      delete '', to: 'devise/registrations#destroy'

    end

  end

end