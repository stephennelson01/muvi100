Rails.application.config.content_security_policy do |policy|
  policy.img_src :self, :https, "https://image.tmdb.org"
end
