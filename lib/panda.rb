require "panda/version"
require "panda/utils"
require "panda/routing/router"
require "panda/routing/mapper"
require "panda/base_controller"
require "panda/dependencies"

module Panda
  class Application
    attr_reader :routes

    def initialize
      @routes = Routing::Router.new
    end

    def call(env)
      return [500, {}, []] if env["PATH_INFO"] == "/favicon.ico"
      get_rack_app(env)
    end

    private

    def get_rack_app(env)
      handler = Routing::Mapper.new(env, routes.endpoints).perform
      if handler
        handler.call(env)
      else
        [
          404,
          {},
          ["Oops! No route for #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"]
        ]
      end
    end
  end
end
