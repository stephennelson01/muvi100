class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = current_user.bookmarks.order(created_at: :desc)
  end

  def create
    tmdb_id = params[:media_id] || params[:tmdb_id]
    kind    = params[:kind]     || "movie"
    title   = params[:title]

    bm = current_user.bookmarks.find_or_initialize_by(tmdb_id: tmdb_id)
    bm.kind  = kind
    bm.title = title if title.present?
    bm.save!

    redirect_back fallback_location: bookmarks_path, notice: "Bookmarked!"
  end

  def destroy
    bm = current_user.bookmarks.find(params[:id])
    bm.destroy!
    redirect_back fallback_location: bookmarks_path, notice: "Removed bookmark."
  end
end
