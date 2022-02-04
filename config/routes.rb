# frozen_string_literal: true

Rails.application.routes.draw do
  scope defaults: { format: 'json' } do
    namespace :api do
      namespace :v1 do
        resources :events, only: %i(index) do
          resources :tickets, only: %i(index create)
        end
        resources :payments, only: :create
      end
    end
  end
end
