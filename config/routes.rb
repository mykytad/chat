Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]

  root "pages#index"
  
  get "about" => "pages#about"
  get "contacts" => "pages#contacts"

  resources :dialogues do
    resources :messages
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
