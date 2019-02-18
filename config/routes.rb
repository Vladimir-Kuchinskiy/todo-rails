# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :boards do
        resources :lists, shallow: true do
          resources :cards, shallow: true, except: :index
        end
      end
    end
  end
end