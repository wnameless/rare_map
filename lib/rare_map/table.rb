require 'active_support/inflector'

module RareMap
  # RareMap::Table defines a table of a database.
  # @author Wei-Ming Wu
  # @!attribute [r] name
  #   @return [String] the name of this Table
  # @!attribute [r] id 
  #   @return [true, false] true if this Table has id, false otherwise
  # @!attribute primary_key
  #   @return [String] the primary key of this Table
  # @!attribute fk_suffix
  #   @return [String] the foreign key suffix of this Table
  # @!attribute columns
  #   @return [Array] an Array of Column of this Table
  class Table
    attr_reader :name, :id
    attr_writer :primary_key
    attr_accessor :fk_suffix, :columns
    
    # Creates a Table.
    #
    # @param name [String] the name of this Table
    # @param opts [Hash] the options of this Table
    # @option opts [true, false] :id the id existence of this Table
    # @option opts [String] :primary_key the primary key of this Table
    # @option opts [String] :fk_suffix the foreign key suffix of this Table
    # @return [Table] a Table object
    def initialize(name, opts = {})
      @name = name
      @id = opts[:id] != false
      @primary_key = opts[:primary_key]
      @columns = []
      @fk_suffix = opts[:fk_suffix] || 'id'
    end
    
    # Returns the primary key of this Table.
    #
    # @return [String, nil] the primary key of this Table
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
    
    # Returns the singular name of this Table.
    #
    # @return [String] the singular name of this Table
    def singularize
      @name.pluralize.singularize
    end
    
    # Returns the plural name of this Table.
    #
    # @return [String] the plural name of this Table
    def pluralize
      @name.pluralize
    end
    
    # Returns the name of this Table if given Column matched.
    #
    # @return [String, nil] the name of this Table if given Column matched, nil otherwise
    def match_foreign_key(column)
      if column.ref_table == @name || foreign_keys.include?(column.name)
        @name if primary_key
      end
    end
    
    # Returns the name of this Table if given primary key matched.
    #
    # @return [String, nil] the name of this Table if given primary key matched, nil otherwise
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