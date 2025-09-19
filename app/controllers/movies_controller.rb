class MoviesController < ApplicationController
  def index
    @movies = Tmdb.get("/movie/popular")["results"] || []
  end

  def show
    movie_id = params[:id]

    # Movie details
    @movie = Tmdb.get("/movie/#{movie_id}")

    # Trailer (grab first YouTube video if present)
    videos = Tmdb.get("/movie/#{movie_id}/videos")["results"] || []
    @trailer = videos.find { |v| v["site"] == "YouTube" && v["type"] == "Trailer" }

    # Providers (logos like Netflix, Prime, Disney+)
    providers = Tmdb.get("/movie/#{movie_id}/watch/providers")["results"] || {}
    region = "US" # adjust based on your audience
    @providers = providers[region].try(:[], "flatrate") || []
  end
end
