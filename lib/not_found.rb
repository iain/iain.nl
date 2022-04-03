# frozen_string_literal: true

class NotFound

  attr_reader :url

  def initialize(url:)
    @url = url
  end

  def html
    Tilt.new("views/layout.slim").render(self) {
      Tilt.new("views/not_found.slim").render(self)
    }
  end

  def description
    "iain's blog"
  end

  def title
    "404"
  end

  def canonical_url
    url.join("/").to_s
  end

end
