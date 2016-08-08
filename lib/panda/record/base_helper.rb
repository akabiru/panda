module Panda
  module Record
    module BaseHelper
      def self.included(base)
        base.extend ClassMethods
      end

      private

      def model_table
        self.class.table
      end

      def current_table_columns
        columns_without_id.map(&:to_s).join(", ")
      end

      def current_table_values
        self.class.properties.keys.map(&method(:send))
      end

      def current_table_placeholders
        (["?"] * (self.class.properties.keys.size - 1)).join(", ")
      end

      def record_values
        columns_without_id.map(&method(:send))
      end

      def update_placeholders(columns = self.class.properties.keys)
        columns.delete(:id)
        columns.keys.map { |column| "#{column} = ?" }.join(", ")
      end

      def update_values(attributes)
        attributes.values << id
      end

      def columns_without_id
        columns ||= self.class.properties.keys
        columns.delete(:id)
        columns
      end

      module ClassMethods
        def column_names_with_constraints
          name_with_constraints = []
          properties.each do |column_name, constraints|
            query_string = []
            query_string << column_name.to_s
            parse_constraints(constraints, query_string)
            name_with_constraints << query_string.join(" ")
          end
          name_with_constraints
        end

        def parse_constraints(constraints, query_string)
          constraints.each do |attribute, value|
            query_string << send(attribute.to_s, value)
          end
        end

        def build_column_methods
          properties.keys.each(&method(:attr_accessor))
        end

        def get_model_object(row)
          return nil unless row
          model ||= new
          properties.keys.each_with_index do |key, index|
            model.send("#{key}=", row[index])
          end
          model
        end

        def type(value)
          value.to_s
        end

        def primary_key(is_primary)
          "PRIMARY KEY AUTOINCREMENT" if is_primary
        end

        def nullable(is_null)
          "NOT NULL" unless is_null
        end

        def default(value)
          "DEFAULT #{value}"
        end
      end
    end
  end
end
