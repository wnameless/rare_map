require 'rare_map/errors'

module RareMap
  # RareMap::Relation defines one of has_one, has_many and has_many_through
  # relations of a database table.
  # @author Wei-Ming Wu
  class Relation
    include Errors
    HAS_ONE = :has_one
    HAS_MANY = :has_many
    HAS_MANY_THROUGH = :has_many_through
    RELATIONS = [HAS_ONE, HAS_MANY, HAS_MANY_THROUGH]
    # @return [Symbol] the type of relation, `:has_one` or `:has_many` or `:has_many_through`
    attr_reader :type
    # @return [String] the foreign key of this Relation based on
    attr_reader :foreign_key
    # @return [String] the table of this Relation refers to
    attr_reader :table
    # @return [String, nil] the table of this Relation goes through
    attr_reader :through
    
    # Creates a Relation.
    #
    # @param type [Symbol] the type, `:has_one` or `:has_many` or `:has_many_through`
    # @param foreign_key [String] the foreign key of this Relation based on
    # @param table [String] the table of this Relation refers to
    # @param through [String, nil] the table of this Relation goes through
    # @return [Relation] the Relation object
    def initialize(type, foreign_key, table, through = nil)
      raise RelationNotDefinedError, 'Relation type not defined.' unless RELATIONS.include? type
      @type, @foreign_key, @table, @through = type, foreign_key, table, through
    end
  end
end