# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "yaml"
require "fileutils"
require "pathname"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load(".env")

require "files"
require "index"
require "not_found"
require "post"
require "post_body"
require "site"
