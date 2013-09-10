require 'uri'

module Jekyll
  class LinkToMapTag < Liquid::Tag

    @@date_format = '%a %d %B %Y, %H:%M'.freeze

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      page = extract_page_from(context)
      if has_a_location? page
        %(<a href="#{ map_url page }" target="_blank">#{ formatted_location page }</a>)
      end
    end

    private
    def extract_page_from(context)
      context['post'] || context['page']
    end

    def has_a_location?(page)
      page['location']
    end

    def map_url(page)
      "http://maps.google.com/?q=#{ URI.escape page['address'] }"
    end

    def formatted_location(page)
      [ page['location'], page['address'] ].join('<br />')
    end
  end
end

Liquid::Template.register_tag('link_to_map', Jekyll::LinkToMapTag)
