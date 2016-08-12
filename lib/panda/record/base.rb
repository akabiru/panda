require_relative "database"
require_relative "base_helper"

module Panda
  module Record
    class Base
      include Record::BaseHelper

      def initialize(attributes = {})
        attributes.each { |column, value| send("#{column}=", value) }
      end

      def save
        query = if id
                  "UPDATE #{model_table} SET " \
                  "#{update_placeholders} WHERE id = ?"
                else
                  "INSERT INTO #{model_table} (#{current_table_columns})" \
                  " VALUES (#{current_table_placeholders})"
                end
        values = id ? record_values << id : record_values
        Database.execute_query(query, values)
        true
      end

      def update(attributes)
        attributes.each do |key, value|
          send("#{key}=", value)
        end
        save
      end

      alias save! save

      def destroy
        self.class.destroy(id)
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

      def self.create(attributes)
        model = new(attributes)
        model.save
        true
      end

      def self.all
        Database.execute_query(
          "SELECT * FROM #{table} ORDER BY id ASC"
        ).map(&method(:get_model_object))
      end

      def self.find(id)
        row = Database.execute_query(
          "SELECT * FROM #{table} WHERE id = ?",
          id.to_i
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

      [%w(last DESC), %w(first ASC)].each do |method_name_and_order|
        define_singleton_method((method_name_and_order[0]).to_sym) do
          row = Database.execute_query(
            "SELECT * FROM #{table} ORDER BY id " \
            "#{method_name_and_order[1]} LIMIT 1"
          ).first
          get_model_object(row) unless row.nil?
        end
      end

      def self.count
        Database.execute_query("SELECT COUNT (*) FROM #{table}")[0][0]
      end

      def self.destroy(id)
        Database.execute_query("DELETE FROM #{table} WHERE id = ?", id)
      end

      def self.destroy_all
        Database.execute_query "DELETE FROM #{table}"
      end
    end
  end
end
