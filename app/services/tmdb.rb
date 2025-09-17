class Tmdb
  API = "https://api.themoviedb.org/3"

  def self.get(path, params = {})
    q = { api_key: ENV["TMDB_API_KEY"], language: "en-US" }.merge(params.transform_keys(&:to_sym))
    key = "tmdb:#{path}?#{q.sort.to_h.to_query}"
    cached = MediaCache.find_by("key = ? AND expires_at > ?", key, Time.current)
    return cached.payload if cached

    res = Faraday.get("#{API}#{path}", q)
    json = JSON.parse(res.body)
    MediaCache.create!(key: key, payload: json, expires_at: 12.hours.from_now)
    json
  end

  def self.search(query); get("/search/multi", query: query); end
  def self.movie(id);     get("/movie/#{id}"); end
  def self.tv(id);        get("/tv/#{id}"); end
  def self.trending;      get("/trending/all/week"); end
end
