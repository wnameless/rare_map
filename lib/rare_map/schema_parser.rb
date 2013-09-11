require 'active_support/inflector'

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
  
  class Table
    attr_reader :name, :id, :columns
    attr_writer :primary_key
    attr_accessor :fk_suffix
    
    def initialize(name, opts = { :id => true, :primary_key => nil })
      @name = name
      @id = opts[:id]
      @primary_key = opts[:primary_key]
      @columns = []
      @fk_suffix = 'id'
    end
    
    def primary_key
      return @primary_key if @primary_key
      return 'id' if @id
      
      candidates = @columns.find_all { |col| col.unique }.map { |col| col.name }
      # return @primary_key if candidates.include? @primary_key
      return 'id' if candidates.include? 'id'
      candidates.find { |c| c =~ eval("/^#{@name}.*id$/") } ||
      candidates.find { |c| c =~ eval("/^#{singularize}.*id$/") } ||
      candidates.find { |c| c =~ eval("/^#{pluralize}.*id$/") } ||
      candidates.first
    end
    
    def singularize
      @name.pluralize.singularize
    end
    
    def pluralize
      @name.pluralize
    end
    
    def match_foreign_key(column)
      if column.references == @name || foreign_keys.include?(column.name)
        @name if primary_key
      end
    end
    
    def match_foreign_key_by_primary_key(pk)
      @name if foreign_keys.include?(pk) && primary_key
    end
    
    private
    
    def foreign_keys
      ["#{@name}_#{fk_suffix}",      "#{@name}#{fk_suffix}",      "#{singularize}_#{fk_suffix}",
       "#{singularize}#{fk_suffix}", "#{pluralize}_#{fk_suffix}", "#{pluralize}#{fk_suffix}"]
    end
  end
  
  class Column
    attr_reader :name, :type
    attr_accessor :unique, :references
    
    def initialize(name, type)
      @name = name
      @type = type
      @unique = false
    end
    
    def unique?
      @unique
    end
    
    def foreign_key?
      @references ? true : false
    end
  end
end