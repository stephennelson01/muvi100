class Bookmark < ApplicationRecord
  belongs_to :user
  validates :media_type, :media_id, presence: true
  validates :unique_key, uniqueness: { scope: :user_id }, allow_nil: true

  before_validation :set_unique_key

  private
  def set_unique_key
    self.unique_key ||= "#{media_type}-#{media_id}"
  end
end
