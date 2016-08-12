require "erb"
require "tilt"

module Panda
  class BaseController
    attr_reader :request

    def initialize(request)
      @request ||= request
    end

    def params
      request.params
    end

    def redirect_to(location, status: 301)
      response([], status, "Location" => location)
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
      layout_template, view_template = layout_view_template(view_name)
      title = view_name.to_s.tr("_", " ")
      layout_template.render(self, title: title) do
        view_template.render(self, locals)
      end
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

    def dispatch(action)
      send(action)
      render(action) unless get_response
      get_response
    end

    private

    def layout_view_template(view_name)
      layout_template = Tilt::ERBTemplate.new(
        File.join(APP_ROOT, "app", "views", "layouts", "application.html.erb")
      )
      view_template = Tilt::ERBTemplate.new(
        File.join(
          APP_ROOT,
          "app",
          "views",
          controller_name,
          "#{view_name}.html.erb"
        )
      )
      [layout_template, view_template]
    end
  end
end
