require 'time' # it enables Time.parse

module Jekyll
  class EventPost < Post
    @@file_ext          = '.ics'.freeze
    @@event_time_format = '%Y%m%dT%H%M%S'.freeze

    def initialize(site, event)
      @event = event
      @site  = site
      @base  = site.source
      @dir   = ::File.dirname(event.url)
      @name  = [ ::File.basename(event.url, '.*'), @@file_ext ].join
      @data  ||= {}

      self.process(name)
      self.categories = []
      self.tags       = []

      self.data['layout']      = 'event'
      self.data['event_url']   = event_url
      self.data['starts_at']   = starts_at
      self.data['ends_at']     = ends_at
      self.data['summary']     = summary
      self.data['location']    = location
    end

    def process(name)
      self.date = event.date
      self.slug = name
    end

    def render(layouts, site_payload)
      # construct payload
      payload = {
        "site" => { "related_posts" => related_posts(site_payload["site"]["posts"]) },
        "page" => self.to_liquid(EXCERPT_ATTRIBUTES_FOR_LIQUID)
      }.deep_merge(site_payload)

      do_layout(payload.merge({"page" => self.to_liquid}), layouts)
    end

    def url
      [@dir, @name].join('/')
    end

    def event_url
      @event_url ||= [site.config['url'], event.url].join
    end

    def starts_at
      _event_time event.data['starts']
    end

    def ends_at
      _event_time event.data['ends']
    end

    def location
      _singleline event.data['address']
    end

    def summary
      "#{ site.config['name'] } #{ city } @ #{ event.data['location'] }"
    end

    def city
      event.data['categories'].capitalize
    end

    private
    attr_reader :event

    def _event_time(time)
      time.utc.strftime(@@event_time_format)
    end

    def _singleline(string)
      string.split("\n").join(' - ')
    end
  end

  class EventGenerator < Generator
    priority :low
    safe true

    def generate(site)
      for_each_event(site) do |event|
        site.posts << Jekyll::EventPost.new(site, event)
      end
    end

    private
    def for_each_event(site)
      site.posts.dup.each do |post|
        yield post if post.data['location']
      end
    end
  end
end
