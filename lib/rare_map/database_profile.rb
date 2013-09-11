require 'rare_map/options'

module RareMap
  # RareMap::DatabaseProfile defines all metadata of a database.
  # @author Wei-Ming Wu
  # @!attribute [r] name
  #   @return [String] the name of this DatabaseProfile
  # @!attribute [r] connection
  #   @return [Hash] the connection config of this DatabaseProfile
  # @!attribute [r] options
  #   @return [Options] the Options of this DatabaseProfile
  # @!attribute schema
  #   @return [String] the schema dump of this DatabaseProfile
  # @!attribute tables
  #   @return [Array] an Array of Table of this DatabaseProfile
  class DatabaseProfile
    attr_reader :name, :connection, :options
    attr_accessor :schema, :tables
    
    # Creates a DatabaseProfile.
    #
    # @param [String] name the name of this DatabaseProfile
    # @param [Hash] connection the connection config of this DatabaseProfile
    # @param [Options] options the Options of this DatabaseProfile
    # @return [DatabaseProfile] a DatabaseProfile object
    def initialize(name, connection, options = nil)
      @name, @connection = name, connection
      @options = options || Options.new
      @tables = []
    end
  end
end