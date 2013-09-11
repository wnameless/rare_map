module RareMap
  class Column
    attr_reader :name, :type
    attr_accessor :unique, :references
    
    def initialize(name, type)
      @name = name
      @type = type
      @unique = false
    end
    
    def unique?
      @unique
    end
    
    def foreign_key?
      @references ? true : false
    end
  end
end