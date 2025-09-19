class TvController < ApplicationController
  def index
    @results = Tmdb.get("/tv/popular")["results"]
  end

  def show
    @show    = Tmdb.get("/tv/#{params[:id]}", append_to_response: "videos,credits")
    @videos  = @show.dig("videos", "results") || []
    @trailer = @videos.find { |v| v["site"] == "YouTube" && v["type"] == "Trailer" }
  end
end
