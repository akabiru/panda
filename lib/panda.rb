require "panda/version"
require "panda/utils"
require "panda/record/base"
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
      request = Rack::Request.new(env)
      handler = mapper.perform(request)
      if handler
        call_controller_action(request, handler[:target])
      else
        process_invalid_request(request)
      end
    end

    private

    def call_controller_action(request, target)
      controller = Object.const_get("#{target[0]}Controller")
      controller.new(request).dispatch(target[1])
    end

    def process_invalid_request(request)
      [
        404,
        {},
        ["Oops! No route for #{request.request_method} #{request.path_info}"]
      ]
    end

    def mapper
      @mapper ||= Routing::Mapper.new(routes.endpoints)
    end
  end
end
