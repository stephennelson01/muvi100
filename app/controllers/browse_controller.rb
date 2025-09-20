class BrowseController < ApplicationController
  def home
    @trending = Tmdb.trending["results"].first(18)
  end

  def trending
    @period = params[:period].presence_in(%w[day week]) || "day"
    page    = params[:page].to_i
    page    = 1 if page <= 0
    data    = Tmdb.get("/trending/all/#{@period}", page: page)
    @results = Array(data["results"])
    @page    = page
    @has_more = @page < (data["total_pages"].to_i.nonzero? || 1000)
  end

  def genres
    @genres = Tmdb.get("/genre/movie/list")["genres"] +
              Tmdb.get("/genre/tv/list")["genres"]
    @genres.uniq! { |g| g["id"] }

    page = params[:page].to_i
    page = 1 if page <= 0

    if params[:with_genres].present?
      data = Tmdb.get("/discover/movie",
        with_genres: params[:with_genres],
        sort_by: "popularity.desc",
        page: page
      )
      @results = Array(data["results"])
      @page    = page
      @has_more = @page < (data["total_pages"].to_i.nonzero? || 1000)
    else
      @results = []
      @page = 1
      @has_more = false
    end
  end

  def anime
    # keep as-is (curated)
    movies = Tmdb.get("/discover/movie", with_genres: 16, sort_by: "popularity.desc")["results"]
    shows  = Tmdb.get("/discover/tv",    with_genres: 16, sort_by: "popularity.desc")["results"]
    @results = (movies + shows).sort_by { |r| -r.fetch("popularity", 0).to_f }.first(40)
  end
end
