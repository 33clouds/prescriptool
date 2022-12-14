Rails.application.routes.draw do
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

  root to: "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
