# frozen_string_literal: true

class Site

  attr_reader :url, :posts, :index, :not_found

  def initialize
    @url = Pathname("https://iain.nl")
    @posts = YAML.load_file("articles/_index.yml", permitted_classes: [Date])
      .map { |path, attributes| [ path, Post.new(path: path, attributes: attributes, url: @url) ] }
      .to_h
    @index = Index.new(posts: @posts.values, url: @url)
    @not_found = NotFound.new(url: @url)
  end

end
