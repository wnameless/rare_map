require 'active_support/core_ext/hash'

module RareMap
  # RareMap::Options defines all available options of RareMap.
  # @author Wei-Ming Wu
  # @!attribute [r] opts
  #   @return [Hash] the details of options
  class Options
    # A default group name
    DEFAULT_GROUP = 'default'
    attr_reader :opts
    
    # Creates a Options.
    #
    # @param raw_opts [Hash] the details of options
    # @return [Options] a Options object
    def initialize(raw_opts = {})
      raw_opts ||= {}
      raw_opts = raw_opts.with_indifferent_access
      @opts = { group: DEFAULT_GROUP,
                primary_key: {},
                foreign_key: { suffix: nil, alias: {} } }.with_indifferent_access
                
      if raw_opts.kind_of? Hash
        if raw_opts[:group]
          @opts[:group] = raw_opts[:group]
        end
        if raw_opts[:primary_key].kind_of? Hash
          @opts[:primary_key] = raw_opts[:primary_key].select { |k, v| k.kind_of? String and v.kind_of? String }
        end
        if raw_opts[:foreign_key].kind_of? Hash and raw_opts[:foreign_key][:suffix].kind_of? String
           @opts[:foreign_key][:suffix] = raw_opts[:foreign_key][:suffix]
        end
        if raw_opts[:foreign_key].kind_of? Hash and raw_opts[:foreign_key][:alias].kind_of? Hash
           @opts[:foreign_key][:alias] = raw_opts[:foreign_key][:alias].select { |k, v| k.kind_of? String and v.kind_of? String }
        end
        if raw_opts[:group].kind_of? String
          @opts[:group] = raw_opts[:group]
        end
      end
    end
    
    # Checks if this Options belongs to a group.
    #
    # @return [true, false] true if this Options contains a group, false otherwise
    def group?
      @opts[:group] != DEFAULT_GROUP
    end
    
    # Returns the name of this Options' group
    #
    # @return [String] the name of this Options' group
    def group
      @opts[:group] || DEFAULT_GROUP
    end
    
    # Returns the primary key of a table specified by this Options
    #
    # @return [String, nil] the primary key of a table specified by this Options
    def find_primary_key_by_table(table_name)
      @opts[:primary_key].values_at(table_name).first
    end
    
    # Returns the table of a foreign key specified by this Options
    #
    # @return [String, nil] the table of a foreign key specified by this Options
    def find_table_by_foreign_key(column_name)
      @opts[:foreign_key][:alias].values_at(column_name).first
    end
    
    # Returns the suffix of a foreign key should have
    #
    # @return [String, nil] the suffix of a foreign key should have
    def fk_suffix
      @opts[:foreign_key][:suffix]
    end
  end
end