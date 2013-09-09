module Jekyll
  class LinkToCityTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      city = extract_city_from(context)
      %(<a href="/#{ city }.html">#{ city.capitalize }</a>)
    end

    private
    def extract_city_from(context)
      context['post']['categories'].first
    end
  end
end

Liquid::Template.register_tag('link_to_city', Jekyll::LinkToCityTag)
