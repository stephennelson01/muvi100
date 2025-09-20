# app/models/user.rb
class User < ApplicationRecord
  # Enable Devise + Google OAuth
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :bookmarks, dependent: :destroy

  # Return the Bookmark record for a given TMDB id (movie or tv), else nil
  def bookmark_for(tmdb_id)
    bookmarks.find_by(tmdb_id: tmdb_id)
  end

  def bookmarked?(tmdb_id)
    bookmark_for(tmdb_id).present?
  end

  # Helper used by Users::OmniauthCallbacksController (safe even if columns don't exist)
  def self.from_google(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name if user.respond_to?(:name=)
      user.avatar_url = auth.info.image if user.respond_to?(:avatar_url=)
      user.confirmed_at = Time.current if user.respond_to?(:confirmed_at=)
    end
  end
end
