module Jekyll
  class LinkToAuthorTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      author = extract_author_from(context)
      %(<a href="https://github.com/#{ author }" target="_blank">@#{ author }</a>)
    end

    private
    def extract_author_from(context)
      ( context['post'] || context['page'] )['author']
    end
  end
end

Liquid::Template.register_tag('link_to_author', Jekyll::LinkToAuthorTag)
