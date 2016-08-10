require "simplecov"
require "coveralls"

Coveralls.wear!

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path("../../spec", __FILE__)

APP_ROOT = __dir__ + "/panda-todo"

require "panda-todo/config/application.rb"
require 'panda'
require "rspec"
require "rack/test"
require "pry"



require_relative "support/factory_girl"
require_relative "support/shared_examples"

ENV["RACK_ENV"] ||= "test"
