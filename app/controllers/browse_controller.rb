class BrowseController < ApplicationController
  def home
    @trending = Tmdb.trending["results"].first(18)
  end

  def trending
    @period = (params[:period] == "day" ? "day" : "week") # site uses week by default
    @results = Tmdb.get("/trending/all/#{@period}")["results"]
    @page    = (params[:page] || 1).to_i
  end

  def genres
    # Static list pulled from TMDB docs (movie genres)
    @genres = [
      [28,"Action"],[12,"Adventure"],[16,"Animation"],[35,"Comedy"],[80,"Crime"],[99,"Documentary"],
      [18,"Drama"],[10751,"Family"],[14,"Fantasy"],[36,"History"],[27,"Horror"],[10402,"Music"],
      [9648,"Mystery"],[10749,"Romance"],[878,"Science Fiction"],[10770,"TV Movie"],[53,"Thriller"],
      [10752,"War"],[37,"Western"]
    ]
    @selected = params[:with_genres].to_s
    @page = (params[:page] || 1).to_i
    @results = @selected.present? ? Tmdb.get("/discover/movie", with_genres: @selected, sort_by: "popularity.desc", page: @page)["results"] : []
  end

  def anime
    # Use Animation genre (16) across movies + tv
    @page = (params[:page] || 1).to_i
    movies = Tmdb.get("/discover/movie", with_genres: 16, sort_by: "popularity.desc", page: @page)["results"]
    shows  = Tmdb.get("/discover/tv",    with_genres: 16, sort_by: "popularity.desc", page: @page)["results"]
    @results = (movies + shows).sort_by { |r| -r.fetch("popularity",0).to_f }.first(60)
  end
end
