class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :bookmarks, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |u|
      u.email = auth.info.email
      u.password = Devise.friendly_token[0, 20]
      u.name = auth.info.name
    end
  end
end
