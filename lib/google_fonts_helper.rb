# taken from https://gist.github.com/travishaynes
module GoogleFontsHelper
  # generates a link tag for Google fonts
  # @param [Hash] fonts contains the font families and weights
  # @return [String] The generated link tag
  # @example Droid+Sans in weights 400 and 700, and Yanone+Kaffeesatz in 300 and 400
  #   = google_fonts_link_tag :droid_sans => [400, 700], :yanone_kaffeesatz => [300, 400]
  def google_fonts_link_tag(fonts = {})
    family = fonts.inject([]) do |result, (font, sizes)|
      # convert font into a String
      font = font.to_s
      # replace underscores with spaces
      font = font.gsub("_", " ")
      # capitalize each word
      font = font.titleize
      # convert spaces into +
      font = font.gsub(" ", "+")
      # return font:sizes where sizes is a comma separated list
      result << "#{font}:#{sizes.join(",")}"
    end
    # the families are separated by pipes
    family = family.join("|")
    # return the link tag
    tag 'link', {
        :rel  => :stylesheet,
        :type => Mime::CSS,
        :href => "http://fonts.googleapis.com/css?family=#{family}"
      },
      false,
      false
  end
end
