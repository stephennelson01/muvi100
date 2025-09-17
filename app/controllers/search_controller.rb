class SearchController < ApplicationController
  def index
    @q = params[:q].to_s.strip
    @results = @q.present? ? Tmdb.search(@q)["results"] : []
  end
end
