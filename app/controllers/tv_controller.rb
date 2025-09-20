class TvController < ApplicationController
  def index
    page = params[:page].to_i
    page = 1 if page <= 0
    data = Tmdb.get("/discover/tv", sort_by: "popularity.desc", page: page)
    @results = Array(data["results"])
    @page    = page
    @has_more = @page < (data["total_pages"].to_i.nonzero? || 1000)
  end

  def show
    @show = Tmdb.get("/tv/#{params[:id]}", append_to_response: "aggregate_credits,videos")
    @trailer = Array(@show.dig("videos","results"))
                .find { |v| v["site"] == "YouTube" && v["type"].to_s.downcase.include?("trailer") }

    @seasons = Array(@show["seasons"]).reject { |s| s["season_number"].to_i == 0 } # skip specials
    @season_number = params[:season].presence&.to_i || @seasons.first&.dig("season_number") || 1
    @season = Tmdb.get("/tv/#{params[:id]}/season/#{@season_number}")

    # Cast (top 12)
    @cast = Array(@show.dig("aggregate_credits","cast")).first(12)

    # Providers for region (reuse movie approach)
    @country_code = params[:cc].presence || "US"
    prov_all = Tmdb.get("/tv/#{params[:id]}", append_to_response: "watch/providers").dig("watch/providers","results") || {}
    prov = prov_all[@country_code] || {}
    @providers = []
    %w[flatrate rent buy free ads].each { |kind| @providers.concat(Array(prov[kind])) if prov[kind].present? }
  end
end
