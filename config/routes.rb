Rails.application.routes.draw do
  # Root
  root "home#index" # or: "browse#home" if you created BrowseController

  # Auth
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # Bookmarks
  resource  :dashboard, only: :show
  resources :bookmarks, only: [:index, :create, :destroy]

  # Search
  get "/search", to: "search#index", as: :search

  # Movies & TV
  resources :movies, only: [:index, :show]   # add index for /movies
  resources :tv,     only: [:index, :show], controller: "tv"

  # Extra “tabs” (use these only if you added BrowseController actions)
  get "/trending", to: "browse#trending", as: :trending
  get "/genres",   to: "browse#genres",   as: :genres
  get "/anime",    to: "browse#anime",    as: :anime
end
