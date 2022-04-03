# frozen_string_literal: true

class Index

  attr_reader :posts, :url

  def initialize(posts:, url:)
    @posts = posts
    @url = url
  end

  def html
    Tilt.new("views/layout.slim").render(self) {
      Tilt.new("views/index.slim").render(self)
    }
  end

  def feed
    Tilt.new("views/feed.builder").render(self)
  end

  def description
    "iain's blog"
  end

  def title
    nil
  end

  def canonical_url
    url.to_s
  end

end
