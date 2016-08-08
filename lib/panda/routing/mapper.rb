module Panda
  module Routing
    class Mapper
      attr_reader :request, :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def perform(request)
        @request = request
        path = request.path_info
        verb = request.request_method

        endpoints[verb].detect do |endpoint|
          match_path_with_endpoint(path, endpoint)
        end
      end

      private

      def match_path_with_endpoint(path, endpoint)
        regex, placeholders = endpoint[:pattern]
        if regex =~ path
          match_data = $~
          placeholders.each do |placeholder|
            request.update_param(placeholder, match_data[placeholder])
          end
          return true
        end
      end
    end
  end
end
