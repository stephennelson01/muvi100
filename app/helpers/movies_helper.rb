module MoviesHelper
  # 🇺🇸 flag from "US"
  def country_flag(code)
    return "" if code.blank?
    code.upcase.chars.map { |c| (0x1F1E6 - 65 + c.ord).chr(Encoding::UTF_8) }.join
  end

  # “2h 36m” from runtime minutes
  def minutes_to_hm(mins)
    return "" unless mins.to_i > 0
    h = mins.to_i / 60
    m = mins.to_i % 60
    h > 0 ? "#{h}h #{m}m" : "#{m}m"
  end

  # JustWatch search link; provider is optional; country like "US"
  def justwatch_link(title, provider_name = nil, country = "US")
    base = "https://www.justwatch.com/#{country.downcase}/search?q="
    q = title.to_s
    q += " #{provider_name}" if provider_name.present?
    "#{base}#{ERB::Util.url_encode(q)}"
  end
end
