module RareMap
  class Relation
    attr_reader :type, :foreign_key, :table, :through
    
    def initialize(type, foreign_key, table, through = nil)
      @type, @foreign_key, @table, @through = type, foreign_key, table, through
    end
  end
end