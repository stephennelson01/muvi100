class TvController < ApplicationController
  def show
    @show = Tmdb.tv(params[:id])
  end
end
