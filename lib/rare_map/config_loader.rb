require 'yaml'

module RareMap
  module ConfigLoader
    OPTS_KEY = 'rare_map_opts'
    
    def load_config(path, file_name = 'database.yml')
      config = YAML.load_file "#{path}#{file_name}"
      organize_config_properties config['rare_map'] || {}
    end
    
    private
    def organize_config_properties(raw_config)
      db_profiles = []
      global_opts = Options.new(raw_config.delete OPTS_KEY)
      
      raw_config.each do |k, v|
        case v.class.name
        when 'Hash'
          if v[OPTS_KEY]
            db_profiles << DatabaseProfile.new(remove_opts(v), Options.new(v[OPTS_KEY]))
          else
            db_profiles << DatabaseProfile.new(v, global_opts)
          end
        when 'Array'
          v = v.reduce(:merge)
          group_opts = Options.new(v.delete(OPTS_KEY) || global_opts.opts, k)
          
          v.each do |db, config|
            if config[OPTS_KEY]
              db_profiles << DatabaseProfile.new(remove_opts(config), Options.new(config[OPTS_KEY], k))
            else
              db_profiles << DatabaseProfile.new(config, group_opts)
            end
          end
        end
      end
      
      db_profiles
    end
    
    def remove_opts(db)
      db.select { |k, _| k != OPTS_KEY }
    end
  end
  
  class DatabaseProfile
    attr_reader :connection, :options
    attr_accessor :schema, :tables
    
    def initialize(connection, options)
      @connection = connection
      @options = options || Options.new
      @tables = []
    end
  end
  
  class Options
    attr_reader :opts
    
    def initialize(raw_opts = nil, group = nil)
      @opts = { 'group'       => 'default',
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
      @opts['group'] != 'default'
    end
    
    def group
      @opts['group'] || 'default'
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
