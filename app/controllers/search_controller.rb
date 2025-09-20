class SearchController < ApplicationController
  def index
    q = params[:q].to_s.strip
    @results = if q.present?
      Array(Tmdb.get("/search/multi", query: q)["results"])
        .select { |r| r["media_type"].in?(%w[movie tv]) }
    else
      []
    end
  end
end
