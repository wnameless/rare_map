require 'active_support/inflector'
require 'active_support/core_ext/hash'

module RareMap
  # RareMap::Model defines the details of an ActiveRecord model.
  # @author Wei-Ming Wu
  # @!attribute [r] db_name
  #   @return [String] the name of the database
  # @!attribute [r] connection
  #   @return [Hash] the connection config of this Model
  # @!attribute [r] table
  #   @return [Table] the Table of this Model
  # @!attribute [r] group
  #   @return [String] the group of this Model
  # @!attribute relations
  #   @return [Array] an Array of Relation of this Model
  class Model
    include Errors
    attr_reader :db_name, :connection, :table, :group
    attr_accessor :relations
    
    # Creates a Model.
    #
    # @param db_name [String] the name of database
    # @param connection [Hash] the connection config of ActiveRecord
    # @param table [Table] the database table
    # @param group [String] the group name of this Model
    # @return [Model] a Model object
    def initialize(db_name, connection, table, group = 'default')
      @db_name, @connection, @table, @group = db_name, connection, table, group
      @relations = []
    end
    
    # Checks if this Model belongs to a group.
    #
    # @return [true, false] true if this Model contains a group, false otherwise
    def group?
      group != 'default'
    end
    
    # Returns the class name of this Model.
    #
    # @return [String] the class name of this Model
    def classify
      "#{table.name}".pluralize.classify
    end
  end
end