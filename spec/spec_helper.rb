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

APP_ROOT = __dir__ + "support/panda_todo"

require 'panda'
require "rspec"
require "rack/test"
require "pry"
require "capybara/rspec"
require_relative "support/panda_todo/config/application"
require_relative "support/factory_girl"
require_relative "support/shared_examples"
require_relative "support/rack_test"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

RSpec.shared_context type: :feature do
  before(:all) do
    app = Rack::Builder.parse_file(
      "#{__dir__}/support/panda_todo/config.ru"
    ).first
    Capybara.app = app
  end
end

ENV["RACK_ENV"] ||= "test"
