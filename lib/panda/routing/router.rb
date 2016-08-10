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

      def root(target) get "/", to: target end

      private

      def route(verb, url, options = {})
        url = "/#{url}" unless url[0] == "/"
        @endpoints[verb] << {
          pattern: match_placeholders(url),
          path: Regexp.new("^#{url}$"),
          target: set_controller_action(options[:to])
        }
      end

      def match_placeholders(path)
        placeholders = []
        path_ = path.gsub(/(:\w+)/) do |match|
          placeholders << match[1..-1].freeze
          "(?<#{placeholders.last}>\\w+)"
        end
        [/^#{path_}$/, placeholders]
      end

      def set_controller_action(string)
        string =~ /^([^#]+)#([^#]+)$/
        [$1.to_camel_case, $2]
      end
    end
  end
end
