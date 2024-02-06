Rails.application.routes.draw do
  devise_for :users

  root "pages#contacts"
  
  get "about" => "pages#about"
  get "contacts" => "pages#contacts"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
