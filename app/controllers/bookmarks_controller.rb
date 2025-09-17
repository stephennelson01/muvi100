class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = current_user.bookmarks.order(created_at: :desc)
  end

  def create
    attrs = {
      user: current_user,
      media_type: params[:media_type],
      media_id: params[:media_id],
      title: params[:title],
      poster_path: params[:poster_path],
      overview: params[:overview]
    }
    @bookmark = current_user.bookmarks.where(media_type: attrs[:media_type], media_id: attrs[:media_id]).first_or_initialize
    @bookmark.assign_attributes(attrs)

    if @bookmark.save
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_back fallback_location: bookmarks_path, notice: "Bookmarked!" }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.destroy
    respond_to do |f|
      f.turbo_stream
      f.html { redirect_back fallback_location: bookmarks_path, notice: "Removed from bookmarks." }
    end
  end
end
