class MoviesController < ApplicationController
  def show
    @movie = Tmdb.movie(params[:id])
  end
end
