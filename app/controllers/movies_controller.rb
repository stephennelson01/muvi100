class MoviesController < ApplicationController
   def index
    page = params[:page].to_i
    page = 1 if page <= 0
    data = Tmdb.get("/discover/movie", sort_by: "popularity.desc", page: page)
    @results = Array(data["results"])
    @page    = page
    @has_more = @page < (data["total_pages"].to_i.nonzero? || 1000)
  end

  def show
    @movie = Tmdb.get(
      "/movie/#{params[:id]}",
      append_to_response: "videos,credits,watch/providers,similar,recommendations"
    )

    # Trailer (YouTube)
    @trailer = Array(@movie.dig("videos", "results"))
                .find { |v| v["site"] == "YouTube" && v["type"].to_s.downcase.include?("trailer") }

    # Cast (top 12)
    @cast = Array(@movie.dig("credits", "cast")).first(12)

    # Providers (TMDB logos) for chosen region
    @country_code = params[:cc].presence || "US"
    prov = (@movie.dig("watch/providers", "results") || {})[@country_code] || {}
    @providers = []
    %w[flatrate rent buy free ads].each { |kind| @providers.concat(Array(prov[kind])) if prov[kind].present? }

    # Watchmode: direct provider URLs (Netflix/Prime/…)
    year = @movie["release_date"].to_s.first(4)
    @source_urls = WatchmodeService.source_url_map(
      title: @movie["title"], year: year, region: @country_code, types: "movie"
    )

    # Choose a primary “Watch” URL with sensible priority
    priority = %w[netflix prime video disney+ hulu max peacock paramount+ apple tv+ crunchyroll]
    @primary_watch_url =
      priority.map { |p| @source_urls[p] }.compact.first ||
      justwatch_fallback(@movie["title"], @country_code)

    # Similar & Recommendations (combine and uniq by id)
    sim  = Array(@movie.dig("similar", "results"))
    recs = Array(@movie.dig("recommendations", "results"))
    merged = (sim + recs)
    seen = {}
    @similar = merged.each_with_object([]) do |m, acc|
      next if seen[m["id"]]
      seen[m["id"]] = true
      acc << m
    end.first(12)
  end

  private

  # Fallback if Watchmode has nothing
  def justwatch_fallback(title, country)
    "https://www.justwatch.com/#{country.downcase}/search?q=#{ERB::Util.url_encode(title)}"
  end
end
