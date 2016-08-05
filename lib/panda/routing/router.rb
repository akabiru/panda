module Panda
  module Routing
    class Router
      attr_reader :endpoints

      def initialize
        @endpoints ||= Hash.new { |h, k| h[k] = [] }
      end

      def draw(&block)
        instance_eval(&block)
      end

      def get(path, options = {}) route "GET", path, options end

      def post(path, options = {}) route "POST", path, options end

      def delete(path, options = {}) route "DELETE", path, options end

      def put(path, options = {}) route "PUT", path, options end

      def patch(path, options = {}) route "PATCH", path, options end

      private

      def route(verb, url, options = {})
        @endpoints[verb] << {
          path: Regexp.new("^#{url}$"),
          target: options.fetch(:to, nil)
        }
      end
    end
  end
end
