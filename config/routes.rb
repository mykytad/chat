Rails.application.routes.draw do
  root "dialogues#index"

  # devise_for :users
  devise_for :users, :controllers => {:registrations => "users/registrations"}

  resources :users, only: [:index, :show]

  resources :dialogues, only: [:index, :create, :update, :destroy] do
    patch :pin
    patch :unpin
    resources :messages, only: [:index, :create, :update, :destroy] do
      patch :read, on: :member
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
