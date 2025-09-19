require "net/http"
require "json"

class WatchmodeService
  BASE_URL = "https://api.watchmode.com/v1"

  def initialize
    @api_key = ENV.fetch("WATCHMODE_API_KEY")
  end

  # media_type: "movie" or "tv"
  # Returns an array of sources from Watchmode (may be empty)
  def streaming_sources(tmdb_id, media_type: "movie")
    url = URI("#{BASE_URL}/title/#{media_type}-#{tmdb_id}/sources/?apiKey=#{@api_key}")
    res = Net::HTTP.get_response(url)
    return [] unless res.is_a?(Net::HTTPSuccess)

    data = JSON.parse(res.body)
    # Basic cleanup: keep only items with web_url and dedupe by "name"+"web_url"
    data
      .select { |h| h["web_url"].to_s.strip != "" }
      .uniq { |h| [h["name"], h["web_url"]] }
  rescue => e
    Rails.logger.error("[Watchmode] sources error: #{e.class}: #{e.message}")
    []
  end
end
