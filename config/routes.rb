Rails.application.routes.draw do
  root "browse#home"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :bookmarks, only: [:index, :create, :destroy]

  get "/search", to: "search#index", as: :search

  # Tabs
  get "/trending", to: "browse#trending", as: :trending
  get "/movies",   to: "movies#index",   as: :movies
  resources :movies, only: :show
  get "/tv",       to: "tv#index",       as: :tv_index
  resources :tv,   only: :show, controller: "tv"
  get "/genres",   to: "browse#genres",  as: :genres
  get "/anime",    to: "browse#anime",   as: :anime
end
