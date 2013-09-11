require 'rare_map/options'

module RareMap
  class DatabaseProfile
    attr_reader :name, :connection, :options
    attr_accessor :schema, :tables
    
    def initialize(name, connection, options)
      @name, @connection = name, connection
      @options = options || Options.new
      @tables = []
    end
  end
end