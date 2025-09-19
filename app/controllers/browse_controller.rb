class BrowseController < ApplicationController
  def home
    @trending = Array(Tmdb.trending["results"]).first(18)
  end

  def trending
    @period  = params[:period] == "day" ? "day" : "week"
    @page    = (params[:page] || 1).to_i
    @results = Tmdb.get("/trending/all/#{@period}", page: @page).fetch("results", [])
  end

  def genres
    movie_genres = Tmdb.get("/genre/movie/list").fetch("genres", [])
    tv_genres    = Tmdb.get("/genre/tv/list").fetch("genres", [])
    @genres = (movie_genres + tv_genres).uniq { |g| g["id"] }

    @selected = params[:with_genres].to_s
    @page     = (params[:page] || 1).to_i

    @results = if @selected.present?
      Tmdb.get("/discover/movie", with_genres: @selected, sort_by: "popularity.desc", page: @page).fetch("results", [])
    else
      []
    end
  end

  def anime
    @page = (params[:page] || 1).to_i
    movies = Tmdb.get("/discover/movie", with_genres: 16, sort_by: "popularity.desc", page: @page).fetch("results", [])
    shows  = Tmdb.get("/discover/tv",    with_genres: 16, sort_by: "popularity.desc", page: @page).fetch("results", [])
    @results = (movies + shows).sort_by { |r| -r.fetch("popularity", 0).to_f }.first(60)
  end
end
