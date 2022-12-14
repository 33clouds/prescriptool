Rails.application.routes.draw do

  # prescriptool.com -> www.prescriptool.com
  match "(*any)",
  to: redirect( subdomain: "www"),
  via: :all,
  constraints: { subdomain: "", domain: "prescriptool.com"  }

  devise_for :users
  resources :prescriptions, only: %i[index show new create] do
    member do
      get :qr
      get :archive
    end
    collection do
      get :archived
    end
  end
  resources :notifications, only: %i[index]

  root to: "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
