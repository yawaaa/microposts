Rails.application.routes.draw do
  root to: "toppages#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "signup", to: "users#new"
  resources :users, only: [:index, :show, :new, :create] do
    # memberでusers/:id/xxx というURLを作成
    member do
      get :followings
      get :followers
      
      get :likes
      # get :favored
      
    end
    # collection do
    #   get :favorings
    # end
  end 
  

  
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]  
  
end
