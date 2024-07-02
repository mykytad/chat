Rails.application.routes.draw do
  root "dialogues#index"

  get "about" => "pages#about"
  get "contacts" => "pages#contacts"

  # devise_for :users
  devise_for :users, :controllers => {:registrations => "users/registrations"}

  resources :users, only: [:index, :show]

  resources :dialogues do
    resources :messages
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
