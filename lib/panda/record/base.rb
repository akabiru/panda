require_relative "database"
require_relative "base_helper"

module Panda
  module Record
    class Base
      include Record::BaseHelper

      class << self
        attr_reader :properties, :table

        private(
          :column_names_with_constraints,
          :parse_constraints,
          :build_column_methods,
          :get_model_object,
          :type,
          :primary_key,
          :nullable,
          :default
        )
      end

      def initialize(attributes = {})
        attributes.each { |column, value| send("#{column}=", value) }
      end

      def self.to_table(name)
        @table = name.to_s
      end

      def self.property(column_name, constraints)
        @properties ||= {}
        @properties[column_name] = constraints
      end

      def self.create_table
        Database.execute_query(
          "CREATE TABLE IF NOT EXISTS #{table} "  \
          "(#{column_names_with_constraints.join(', ')})"
        )
        build_column_methods
      end

      def save
        query = if id
                  "UPDATE #{model_table} SET #{update_placeholders}" \
                  " WHERE  id = ?"
                else
                  "INSERT INTO #{model_table} (#{current_table_columns})" \
                  " VALUES (#{current_table_placeholders})"
                end
        values = id ? (record_values << send(id)) : record_values
        Database.execute_query(query, values)
      end

      def update(attributes)
        Database.execute_query(
          "UPDATE #{model_table} SET " \
          "#{update_placeholders(attributes)} WHERE  id = ?",
          update_values(attributes)
        )
      end

      def destroy
        self.class.destroy(id)
      end

      def self.create(attributes)
        model = new(attributes)
        model.save
        true
      end

      def self.all
        Database.execute_query(
          "SELECT * FROM #{table} ORDER BY id DESC"
        ).map(&method(:get_model_object))
      end

      def self.find(id)
        row = Database.execute_query(
          "SELECT * FROM #{table} WHERE id = ?", id.to_i
        ).first
        get_model_object(row)
      end

      def self.find_by(option)
        row = Database.execute_query(
          "SELECT * FROM #{table} WHERE #{option.keys.first} = ?",
          option.values.first
        ).first
        get_model_object(row)
      end

      def self.count
        Database.execute_query("SELECT COUNT (*) FROM #{table}")[0][0]
      end

      def self.destroy(id)
        Database.execute_query("DELETE FROM #{table} WHERE id = ?", id)
      end
    end
  end
end
