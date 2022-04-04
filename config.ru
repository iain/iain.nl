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
    path = request.path.delete_prefix("/")

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
    headers = {
      "Content-Type"   => Files.content_type(path),
      "Content-Length" => body.bytesize,
      "Cache-Control"  => "no-cache, no-store, must-revalidate",
    }
    [ status, headers, [ body ] ]
  end

end

use Rack::CommonLogger
run MyApp.new
