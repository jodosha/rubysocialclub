##
# Liquid filter to convert multiline sting into HTML break lines.
#
module Jekyll
  module MultilineFilter
    def multiline(text)
      text.gsub "\n", "<br />"
    end
  end
end

Liquid::Template.register_filter(Jekyll::MultilineFilter)
