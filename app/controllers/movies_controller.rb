class MoviesController < ApplicationController
  def index
    @results = Tmdb.get("/discover/movie", sort_by: "popularity.desc")["results"]
  end

  def show
    @movie = fetch_movie(params[:id])

    # If TMDB didn’t return a movie, bail out with a friendly message
    unless @movie.present? && !@movie.is_a?(Hash) || @movie["id"].present?
      redirect_to movies_path, alert: "Sorry, that movie could not be found."
      return
    end

    # Trailer
    vids     = Array(@movie.dig("videos", "results"))
    @trailer = vids.find { |v| v["site"] == "YouTube" && v["type"].to_s.downcase.include?("trailer") }

    # Cast
    @cast = Array(@movie.dig("credits", "cast")).first(12)

    # Providers from TMDB (for logos)
    @country_code = params[:cc].presence || "US"
    prov = (@movie.dig("watch/providers", "results") || {})[@country_code] || {}
    @providers = []
    %w[flatrate rent buy free ads].each { |kind| @providers.concat(Array(prov[kind])) if prov[kind].present? }

    # Direct source URLs from Watchmode
    year = @movie["release_date"].to_s.first(4)
    @source_urls = WatchmodeService.source_url_map(
      title: @movie["title"], year: year, region: @country_code, types: "movie"
    )

    # Pick a primary watch URL (Netflix/Prime/etc) or fall back to JustWatch search
    priority = %w[netflix prime video disney+ hulu max peacock paramount+ apple tv+ crunchyroll]
    @primary_watch_url =
      priority.map { |p| @source_urls[p] }.compact.first ||
      justwatch_fallback(@movie["title"], @country_code)
  end

  private

  def fetch_movie(id)
    Tmdb.get("/movie/#{id}", append_to_response: "videos,credits,watch/providers")
  rescue StandardError
    nil
  end

  # Fallback if Watchmode has nothing
  def justwatch_fallback(title, country)
    "https://www.justwatch.com/#{country.downcase}/search?q=#{ERB::Util.url_encode(title.to_s)}"
  end
end
