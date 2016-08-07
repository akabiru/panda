require "sqlite3"

module Panda
  module Record
    class Database
      def self.connection
        @db ||= SQLite3::Database.new(File.join(APP_ROOT, "db", "app.db"))
      end

      def self.execute_query(*query)
        connection.execute(*query)
      end
    end
  end
end
