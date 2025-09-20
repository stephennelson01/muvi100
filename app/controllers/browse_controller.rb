class BrowseController < ApplicationController
  def home
    # Pull trending and paginate locally for the grid; hero uses first slides separately in view if you want
    res = Tmdb.trending # expected to return {"results" => [...]}
    all = Array(res["results"])

    @page = (params[:page] || 1).to_i
    per  = 18
    offset = (@page - 1) * per

    @trending = all.slice(offset, per) || []
    @next_url = (offset + per < all.size) ? root_path(page: @page + 1) : nil
  end

  def trending
    @period  = (params[:period] == "day" ? "day" : "week")
    @results = Tmdb.get("/trending/all/#{@period}")["results"]
  end

  def genres
    @genres = Tmdb.get("/genre/movie/list")["genres"] +
              Tmdb.get("/genre/tv/list")["genres"]
    @genres.uniq! { |g| g["id"] }

    if params[:with_genres].present?
      @results = Tmdb.get("/discover/movie",
                          with_genres: params[:with_genres],
                          sort_by: "popularity.desc")["results"]
    else
      @results = []
    end
  end

  def anime
    movies = Tmdb.get("/discover/movie", with_genres: 16, sort_by: "popularity.desc")["results"]
    shows  = Tmdb.get("/discover/tv",    with_genres: 16, sort_by: "popularity.desc")["results"]
    @results = (movies + shows).sort_by { |r| -r.fetch("popularity", 0).to_f }.first(40)
  end
end
