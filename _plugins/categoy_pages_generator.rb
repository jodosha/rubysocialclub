module Jekyll
  class CategoryPage < Page
    def initialize(site, base, category)
      @site = site
      @base = base
      @dir = ""
      @name = "#{category}.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      self.data['title'] = category.capitalize
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        site.categories.keys.each do |category|
          site.pages << CategoryPage.new(site, site.source, category)
        end
      end
    end
  end
end
