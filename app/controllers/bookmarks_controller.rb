# app/controllers/bookmarks_controller.rb
class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = current_user.bookmarks.order(created_at: :desc)
  end

  def create
    b = current_user.bookmarks.find_or_initialize_by(
      tmdb_id: params[:tmdb_id],
      media_type: params[:media_type] # "movie" or "tv"
    )

    # Optional cached fields
    b.title = params[:title] if params[:title].present?
    b.poster_path = params[:poster_path] if params[:poster_path].present?

    if b.save
      redirect_back fallback_location: root_path, notice: "Bookmarked!"
    else
      redirect_back fallback_location: root_path, alert: b.errors.full_messages.to_sentence
    end
  end

  def destroy
    b = current_user.bookmarks.find(params[:id])
    b.destroy
    redirect_back fallback_location: bookmarks_path, notice: "Removed."
  end
end
