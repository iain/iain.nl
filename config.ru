# frozen_string_literal: true

# use Rack::Static, root: "public", urls: ["fonts/"]
# use Rack::Static, root: "out", urls: [""], index: "index.html"

require "pathname"
require "pry"

class MyApp

  def initialize
    @root = Pathname.new("out")
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path[1..]
    path = "index.html" if path == ""

    if @root.join(path).exist?
      body = @root.join(path).read
      headers = {
        "content-type" => content_type(path),
      }
      [ 200, headers, [ body ] ]
    else
      [ 404, { "content-type" => "text/html" }, [ @root.join("404.html").read ] ]
    end
  end

  def content_type(file)
    case file
    when /\.html$/  then "text/html"
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
