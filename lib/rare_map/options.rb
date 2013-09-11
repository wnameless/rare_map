module RareMap
  # RareMap::Options defines all available options of RareMap. 
  class Options
    DEFAULT_GROUP = 'default'
    attr_reader :opts
    
    # RareMap::Options.new raw_opts, group
    # raw_opts is simply a hash, please refer to the README.rdoc for details
    # group is where this Options belongs to
    def initialize(raw_opts = nil, group = nil)
      @opts = { 'group'       => DEFAULT_GROUP,
                'primary_key' => {},
                'foreign_key' => { 'suffix' => nil, 'alias' => {} } }
                
      if raw_opts and raw_opts.kind_of? Hash
        if raw_opts['group']
          @opts['group'] = raw_opts['group']
        end
        if raw_opts['primary_key'].kind_of? Hash
          @opts['primary_key'] = raw_opts['primary_key'].select { |k, v| k.kind_of? String and v.kind_of? String }
        end
        if raw_opts['foreign_key'] and raw_opts['foreign_key']['suffix'].kind_of? String
           @opts['foreign_key']['suffix'] = raw_opts['foreign_key']['suffix']
        end
        if raw_opts['foreign_key'] and raw_opts['foreign_key']['alias'].kind_of? Hash
           @opts['foreign_key']['alias'] = raw_opts['foreign_key']['alias'].select { |k, v| k.kind_of? String and v.kind_of? String }
        end
      end
      @opts['group'] = group if group.kind_of? String
    end
    
    # Returns true if this Options contains a group, false otherwise
    def group?
      @opts['group'] != DEFAULT_GROUP
    end
    
    # Returns the name of this Options' group
    def group
      @opts['group'] || DEFAULT_GROUP
    end
    
    # Returns the primary key of a table specified by this Options
    def find_primary_key_by_table(table_name)
      @opts['primary_key'].values_at(table_name).first
    end
    
     # Returns the table of a foreign key specified by this Options
    def find_table_by_foreign_key(column_name)
      @opts['foreign_key']['alias'].values_at(column_name).first
    end
    
    # Returns the suffix of a foreign key should have
    def fk_suffix
      @opts['foreign_key']['suffix']
    end
    
    # Returns the @opts.to_s
    def to_s
      @opts.to_s
    end
  end
end