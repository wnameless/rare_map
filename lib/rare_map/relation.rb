require 'rare_map/errors'

module RareMap
  # RareMap::Relation defines one of has_one, has_many and has_many_through
  # relations of a database table.
  # @author Wei-Ming Wu
  # @!attribute [r] type
  #   @return [Symbol] the type of relation, `:has_one` or `:has_many` or `:has_many_through`
  # @!attribute [r] foreign_key
  #   @return [String] the foreign key of this Relation based on
  # @!attribute [r] table
  #   @return [String] the table of this Relation refers to
  # @!attribute [r] through
  #   @return [String, nil] the table of this Relation goes through
  class Relation
    # The :has_one association.
    HAS_ONE = :has_one
    # The :has_many association.
    HAS_MANY = :has_many
    # The :has_many_through association.
    HAS_MANY_THROUGH = :has_many_through
    # All three kinds of relations
    RELATIONS = [HAS_ONE, HAS_MANY, HAS_MANY_THROUGH]
    include Errors
    attr_reader :type, :foreign_key, :table, :through
    
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