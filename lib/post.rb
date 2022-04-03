# frozen_string_literal: true

class Post

  attr_reader :path, :attributes, :url

  def initialize(path:, attributes:, url:)
    @path = path
    @attributes = attributes
    @url = url
  end

  def body
    PostBody.render(source)
  end

  def title
    attributes.fetch("title")
  end

  def summary
    attributes.fetch("summary")
  end
  alias_method :description, :summary

  def publish
    attributes.fetch("publish")
  end

  def publish_date
    publish.strftime("%Y-%m-%d")
  end

  def publish_formatted
    publish.strftime("%e %B, %Y")
  end

  def canonical_url
    url.join(path).to_s
  end

  def html
    Tilt.new("views/layout.slim").render(self) {
      Tilt.new("views/post.slim").render(self)
    }
  end

  private

  def source
    File.open("articles/#{path}.md", "r:utf-8").read
  end

end
