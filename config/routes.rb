Rails.application.routes.draw do
  root "dialogues#index"

  get "about" => "pages#about"
  get "contacts" => "pages#contacts"

  # devise_for :users
  devise_for :users, :controllers => {:registrations => "users/registrations"}

  resources :users, only: [:index, :show]

  resources :dialogues, only: [:index, :create, :update, :destroy] do
    patch :pin
    patch :unpin
    resources :messages
  end

  resources :pin_dialogue, only: [:create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
