module Jekyll
  class LinkToCalendarTag < Liquid::Tag

    @@date_format = '%a %d %B %Y, %H:%M'.freeze

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      page = extract_page_from(context)
      %(<a href="#{ calendar_url page }" target="_blank">#{ formatted_date page }</a>)
    end

    private
    def extract_page_from(context)
      context['post'] || context['page']
    end

    def calendar_url(page)
      "#{ page['id'] }.ics"
    end

    def formatted_date(page)
      page['starts'].strftime(@@date_format)
    end
  end
end

Liquid::Template.register_tag('link_to_calendar', Jekyll::LinkToCalendarTag)
