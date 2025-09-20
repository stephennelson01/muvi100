class SearchController < ApplicationController
  def index
    @q = params[:q].to_s.strip
    @results = []
    @page    = (params[:page] || 1).to_i
    @next_url = nil

    if @q.present?
      res = Tmdb.get("/search/multi", query: @q, page: @page, include_adult: false)
      all = Array(res["results"]).reject { |r| r["media_type"] == "person" }
      @results = all
      total_pages = res["total_pages"].to_i
      @next_url = search_path(q: @q, page: @page + 1) if @page < total_pages
    end
  end
end
