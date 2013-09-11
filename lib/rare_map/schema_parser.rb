require 'rare_map/table'
require 'rare_map/column'

module RareMap
  module SchemaParser
    def parse_schema(schema)
      tables = []
      
      schema.split(/\n/).each do |line|
        case line.strip!
        when /^create_table/
          name = line.match(/create_table\s+['"]([^'"]+)['"]/)[1]
          id = line.match(/(:id\s*=>|id:)\s*false/) ? false : true
          pk = line.match(/(:primary_key\s*=>|primary_key:)\s*['"](.+)['"]/)
          primary_key = pk[2] if pk
          tables << Table.new(name, :id => id, :primary_key => primary_key)
        when /^t\./
          name = line.match(/t\.\w+\s+['"]([^'"]+)['"]/)[1]
          type = line.match(/t\.(\w+)\s+/)[1]
          tables.last.columns << Column.new(name, type)
        when /^add_index\s+.*\[\s*['"]([^'"]+)['"]\s*\].*(:unique\s*=>|unique:)\s*true/
          unique_column = line.match(/add_index\s+.*\[\s*['"]([^'"]+)['"]\s*\].*(:unique\s*=>|unique:)\s*true/)[1]
          column = tables.last.columns.find { |col| col.name == unique_column }
          column.unique = true
        end
      end
      
      tables
    end
  end
end