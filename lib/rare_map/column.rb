module RareMap
  # RareMap::Column defines a column of a database table.
  # @author Wei-Ming Wu
  # @!attribute [r] name
  #   @return [String] the name of this Column
  # @!attribute [r] type
  #   @return [String] the type of this Column
  # @!attribute unique
  #   @return [true, false] the uniqueness of this Column
  # @!attribute ref_table
  #   @return [String] the reference table of this Column
  class Column
    attr_reader :name, :type
    attr_accessor :unique
    attr_accessor :ref_table
    
    # Creates a Column.
    #
    # @param name [String] the name of column
    # @param type [String] the type of column
    # @return [Column] a Column object
    def initialize(name, type, opts = {})
      @name = name
      @type = type
      @unique = opts[:unique] == true
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