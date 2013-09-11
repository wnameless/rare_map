module RareMap
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
end