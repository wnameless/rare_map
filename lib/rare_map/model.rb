require 'active_support/inflector'

module RareMap
  class Model
    attr_reader :db_name, :connection, :table, :group, :relations
    
    def initialize(db_name, connection, table, group = 'default')
      @db_name, @connection, @table, @group = db_name, connection, table, group
      @relations = []
    end
    
    def group?
      group != 'default'
    end
    
    def classify
      "#{table.name}".pluralize.classify
    end
  end
end