class Bookmark < ApplicationRecord
  belongs_to :user

  validates :tmdb_id, presence: true
  validates :media_type, presence: true, inclusion: { in: %w[movie tv] }
  validates :tmdb_id, uniqueness: { scope: [:user_id, :media_type] }
end
