require "bundler/setup"
Bundler.require(:default)

require "yaml"
require "fileutils"


class Post

  attr_reader :path, :attributes

  def initialize(path, attributes)
    @path = path
    @attributes = attributes
  end

  def body
    @body ||= markdown.render(source)
  end

  def title
    attributes.fetch("title")
  end

  def summary
    attributes.fetch("summary")
  end

  def publish
    attributes.fetch("publish")
  end

  def publish_date
    publish.strftime("%Y-%m-%d")
  end

  def publish_formatted
    publish.strftime("%e %B, %Y")
  end

  def wp
    attributes["wp"]
  end

  def html
    Tilt.new("views/post.slim").render(self)
  end

  def disqus_id
    if wp
      "#{wp} http://iain.nl/?p=#{wp}"
    else
      path
    end
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(
      Renderer.new,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      strikethrough: true,
    )
  end

  def source
    @source ||= File.open("articles/#{path}.md", "r:utf-8").read
  end

  def css
    self.class.css
  end

  def self.css
    @css ||= Sass::Engine.new(
      File.read("views/post.sass"),
      syntax: :sass,
      style: :compressed,
      load_paths: ["views"],
    ).render
  end

end

class Renderer < Redcarpet::Render::HTML

  def block_code(code, language)
    lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText

    # XXX HACK: Redcarpet strips hard tabs out of code blocks,
    # so we assume you're not using leading spaces that aren't tabs,
    # and just replace them here.
    if lexer.tag == 'make'
      code.gsub!(/^    /, "\t")
    end

    formatter = rouge_formatter(
      wrap: false
    )

    compiled = formatter.format(lexer.lex(code))
    "<pre>#{compiled}</pre>"
  end

  protected
  def rouge_formatter(opts={})
    Rouge::Formatters::HTML.new(opts)
  end

end

FileUtils.rm_r("out")
FileUtils.mkdir_p("out")

posts = YAML.load_file("articles/_index.yml").map { |k,v| Post.new(k, v) }

posts.each do |post|
  File.open("out/#{post.path}", "w:utf-8") do |f|
    f << post.html
  end
end

class Index

  attr_reader :posts

  def initialize(posts)
    @posts = posts
  end

  def html
    Tilt.new("views/index.slim").render(self)
  end

  def feed
    Tilt.new("views/feed.builder").render(self)
  end

  def css
    @css ||= Sass::Engine.new(
      File.read("views/index.sass"),
      syntax: :sass,
      style: :compressed,
      load_paths: ["views"],
    ).render
  end

end

class NotFound

  def html
    Tilt.new("views/not_found.slim").render(self)
  end

  def css
    @css ||= Sass::Engine.new(
      File.read("views/index.sass"),
      syntax: :sass,
      style: :compressed,
      load_paths: ["views"],
    ).render
  end

end

index = Index.new(posts)

File.open("out/index.html", "w:utf-8") do |f|
  f << index.html
end

File.open("out/feed", "w:utf-8") do |f|
  f << index.feed
end

File.open("out/404.html", "w:utf-8") do |f|
  f << NotFound.new.html
end

Dir["public/*"].each do |file|
  FileUtils.cp(file, "out/#{File.basename(file)}")
end
