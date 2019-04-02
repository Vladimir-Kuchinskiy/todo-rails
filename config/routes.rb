# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :boards do
        resources :lists, shallow: true do
          resources :cards, shallow: true, except: :index do
            resource :move, only: :create
          end
          resource :move, only: :create
        end
      end
      resources :teams do
        resources :boards, only: %i[show create update destroy]
        resources :invitations, shallow: true, only: %i[create destroy]
      end
      get '/invitations', to: 'invitations#index'
      resource :profile, only: %i[show update]
      resources :subscriptions, only: %i[index new create]
    end

    post 'auth/login', to: 'authentication#create'
    post 'signup', to: 'users#create'
  end
end
