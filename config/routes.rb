Rails.application.routes.draw do
  resources :routes
  resources :locations
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  put "/routes", to: "routes#update"
end
