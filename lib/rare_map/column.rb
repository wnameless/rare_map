module RareMap
  # RareMap::Column defines a column of a database table.
  # @author Wei-Ming Wu
  class Column
    # @return [String] the name of column
    attr_reader :name
    # @return [String] the type of column
    attr_reader :type
    # @return [True, False] the uniqueness of column
    attr_accessor :unique
    # @return [String] the reference table of column
    attr_accessor :ref_table
    
    # Creates a Column.
    #
    # @param name [String] the name of column
    # @param type [String] the type of column
    # @return [Column] a Column object
    def initialize(name, type)
      @name = name
      @type = type
      @unique = false
    end
    
    # Checks if this Column is unique.
    #
    # @return [true, false] true if it's unique, false otherwise 
    def unique?
      @unique
    end
    
    # Checks if this Column is a foreign key.
    #
    # @return [true, false] true if it's a foreign key, false otherwise 
    def foreign_key?
      @ref_table ? true : false
    end
  end
end