# frozen_string_literal: true

require "yaml"
require "fileutils"
require "pathname"
require "bundler/setup"
Bundler.require(:default)

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "index"
require "post"
require "post_body"
require "not_found"
require "site"
