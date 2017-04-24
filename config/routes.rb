Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :favorite_products, only: :index do
      get :users, on: :member
    end

    resources :products do
      get :favourite_users, on: :member
    end

    resources :users do
      get :favourite_products, on: :member
    end
  end

  resources :favorite_products, only: [:index, :create, :destroy]
end
