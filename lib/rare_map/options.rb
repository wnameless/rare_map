module RareMap
  class Options
    DEFAULT_GROUP = 'default'
    attr_reader :opts
    
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
    
    def group?
      @opts['group'] != DEFAULT_GROUP
    end
    
    def group
      @opts['group'] || DEFAULT_GROUP
    end
    
    def find_primary_key_by_table(table_name)
      @opts['primary_key'].each { |k, v| return v if k == table_name }
      nil
    end
    
    def find_table_by_foreign_key(column_name)
      @opts['foreign_key']['alias'].each { |k, v| return v if k == column_name }
      nil
    end
    
    def fk_suffix
      @opts['foreign_key']['suffix']
    end
    
    def to_s
      @opts.to_s
    end
  end
end