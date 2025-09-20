Rails.application.routes.draw do
  root "browse#home"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :bookmarks, only: [:index, :create, :destroy]

  get "/search", to: "search#index", as: :search

  get "/trending", to: "browse#trending", as: :trending
  resources :movies, only: [:index, :show]
  get "/tv", to: "tv#index", as: :tv_index
  resources :tv, only: :show, controller: "tv"
  get "/genres", to: "browse#genres", as: :genres
  get "/anime",  to: "browse#anime",  as: :anime
end
