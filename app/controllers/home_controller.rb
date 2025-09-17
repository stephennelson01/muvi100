class HomeController < ApplicationController
  def index
    @trending = Tmdb.trending["results"].first(12)
  end
end
