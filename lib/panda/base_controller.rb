require "erb"
require "tilt"

module Panda
  class BaseController
    attr_reader :request

    def initialize(env)
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end

    def response(body, status = 200, header = {})
      @response = Rack::Response.new(body, status, header)
    end

    def get_response
      @response
    end

    def render(*args)
      response(render_template(*args))
    end

    def render_template(view_name, locals = {})
      template = File.join("app", "views", controller_name, "#{view_name}.erb")
      Tilt::ERBTemplate.new(template).render(locals.merge(view_assigns))
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

    def dispatch(action)
      send(action)
      render(action) unless get_response
      get_response
    end

    def self.action(action_name)
      -> (env) { new(env).dispatch(action_name) }
    end

    private

    def view_assigns
      vars = {}
      instance_variables.each do |name|
        vars[name[1..-1]] = instance_variable_get(name)
      end
      vars
    end
  end
end
