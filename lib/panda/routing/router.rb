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

      %w(get post delete put patch).each do |method_name|
        define_method(method_name) do |path, options|
          route method_name.upcase, path, options
        end
      end

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
