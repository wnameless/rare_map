require 'rare_map/errors'

module RareMap
  # RareMap::Relation defines one of has_one, has_many and has_many_through
  # relations of a database table. 
  class Relation
    include Errors
    HAS_ONE = :has_one
    HAS_MANY = :has_many
    HAS_MANY_THROUGH = :has_many_through
    RELATIONS = [HAS_ONE, HAS_MANY, HAS_MANY_THROUGH]
    attr_reader :type, :foreign_key, :table, :through
    
    # RareMap::Relation.new type, foreign_key, table, through = nil
    # type is one out of :has_one, :has_many, :has_many_through
    # foreign_key is the name of the column this Relation based on
    # table is the name of the table this Relation refers to
    # through is the name of the table this Relation goes through
    def initialize(type, foreign_key, table, through = nil)
      raise RelationNotDefinedError, 'Relation type not defined.' unless RELATIONS.include? type
      @type, @foreign_key, @table, @through = type, foreign_key, table, through
    end
  end
end