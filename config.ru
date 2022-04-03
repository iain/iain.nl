# frozen_string_literal: true

require_relative "config/application"

class MyApp

  def initialize
    @out    = Pathname.new("out")
    @public = Pathname.new("public")
    @site   = Site.new
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path[1..] # rubocop:disable Performance/ArraySemiInfiniteRangeSlice

    if path == ""
      body = @site.index.html
      respond(path: path, body: body)
    elsif (post = @site.posts[path])
      body = post.html
      respond(path: path, body: body)
    elsif @out.join(path).exist?
      body = @out.join(path).read
      respond(path: path, body: body)
    elsif @public.join(path).exist?
      body = @public.join(path).read
      respond(path: path, body: body)
    else
      body = @site.not_found.html
      respond(path: nil, body: body, status: 404)
    end
  end

  private

  def respond(path:, body:, status: 200)
    headers = { "content-type" => content_type(path) }
    [ status, headers, [ body ] ]
  end

  def content_type(file)
    case file
    # when /\.html$/  then "text/html"
    when /\.css$/   then "text/css"
    when /\.jpe?g$/ then "image/jpeg"
    when /\.png$/   then "image/png"
    when /\.ico$/   then "image/ico"
    when /\.woff2$/ then "font/woff2"
    when /\.woff$/  then "font/woff"
    when "feed"     then "application/rss+xml"
    else "text/html"
    end
  end

end

run MyApp.new
