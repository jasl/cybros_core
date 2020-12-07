# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :account, module: "accounts" do
    resource :password, only: %i[show update]
    resource :profile, only: %i[show update]
  end

  namespace :admin do
    root to: "home#index"

    resources :users, except: %i[destroy] do
      collection do
        resources :invitations, only: %i[new create], module: :users
      end

      member do
        patch :lock
        patch :unlock
        patch :resend_confirmation_mail
        patch :resend_invitation_mail
      end
    end
  end

  devise_scope :user do
    namespace :users, as: "user" do
      resource :registration,
               only: %i[new create],
               path: "",
               path_names: { new: "sign_up" }

      resource :invitation,
               path: "invitation" do
        get :edit, path: "accept", as: :accept
        get :destroy, path: "remove", as: :remove
      end
    end
  end

  devise_for :users, skip: %i[registrations invitations], controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    sessions: "users/sessions"
  }

  get "users", to: redirect("/users/sign_up")

  get "401", to: "errors#unauthorized", as: :unauthorized
  get "403", to: "errors#forbidden", as: :forbidden
  get "404", to: "errors#not_found", as: :not_found

  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
