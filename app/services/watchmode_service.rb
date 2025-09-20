# app/services/watchmode_service.rb
class WatchmodeService
  API = "https://api.watchmode.com/v1"

  class << self
    def key = ENV["WATCHMODE_API_KEY"]

    def search_title(title, year: nil, types: "movie")
      return nil if key.blank? || title.blank?

      res = Faraday.get("#{API}/search/", {
        apiKey: key, search_field: "name", search_value: title, types: types
      })

      data = begin
        JSON.parse(res.body)
      rescue StandardError
        {}
      end

      results = Array(data["title_results"])
      return nil if results.empty?

      year.present? ? (results.find { |r| r["year"].to_s == year.to_s } || results.first) : results.first
    end

    def sources_for_title_id(id, region: "US")
      return [] if key.blank? || id.blank?

      res = Faraday.get("#{API}/title/#{id}/sources/", {
        apiKey: key, regions: region, append_source_images: "false"
      })

      data = begin
        JSON.parse(res.body)
      rescue StandardError
        []
      end

      Array(data)
    end

    def normalize(name)
      n = name.to_s.downcase.strip
      n = n.sub("amazon ", "")
      {
        "prime video" => "prime video", "amazon prime video" => "prime video",
        "netflix" => "netflix", "disney+" => "disney+", "disney plus" => "disney+",
        "hulu" => "hulu", "max" => "max", "hbo max" => "max", "peacock" => "peacock",
        "paramount+" => "paramount+", "paramount plus" => "paramount+",
        "apple tv+" => "apple tv+", "apple tv plus" => "apple tv+",
        "crunchyroll" => "crunchyroll"
      }[n] || n
    end

    # { "netflix" => "https://...", "prime video" => "https://...", ... }
    def source_url_map(title:, year:, region: "US", types: "movie")
      found = search_title(title, year: year, types: types)
      return {} unless found && found["id"]

      all = sources_for_title_id(found["id"], region: region)
      preferred_types = %w[sub free rent buy]
      best = {}

      all.each do |s|
        next if s["web_url"].blank?
        norm = normalize(s["name"] || s["source_name"])
        cur  = best[norm]
        rank = preferred_types.index(s["type"].to_s) || 99
        cur_rank = cur ? (preferred_types.index(cur[:type]) || 99) : 999
        best[norm] = { url: s["web_url"], type: s["type"].to_s } if rank < cur_rank
      end

      best.transform_values { |h| h[:url] }
    end
  end
end
