module RareMap
  class Model
    attr_reader :connection, :table, :group, :relations, :db_name
    
    def initialize(connection, table, group = 'default', db_name)
      @connection, @table, @group, @db_name = connection, table, group, db_name
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