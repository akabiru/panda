module Panda
  module Routing
    class Mapper
      def initialize(env, endpoints)
        @env = env
        @endpoints = endpoints
      end

      def perform
        path = @env["PATH_INFO"]
        verb = @env["REQUEST_METHOD"]

        @endpoints[verb].each do |route|
          next unless route[:path].match(path)
          next unless route[:target] =~ /^([^#]+)#([^#]+)$/
          controller_name = $1.to_camel_case
          controller = Object.const_get("#{controller_name}Controller")
          return controller.action($2)
        end if @endpoints[verb]
        false
      end
    end
  end
end
