require 'yaml'
require 'rare_map/errors'
require 'rare_map/database_profile'
require 'rare_map/options'

module RareMap
  module ConfigLoader
    include Errors
    OPTS_KEY = 'rare_map_opts'
    
    def load_config(path, file_name = 'rare_map.yml')
      raise ConfigNotFoundError unless File.exist? File.join(path, file_name)
      config = YAML.load_file File.join(path, file_name)
      organize_config_properties config['rare_map'] || config || {}
    end
    
    private
    
    def organize_config_properties(raw_config)
      db_profiles = []
      global_opts = Options.new(raw_config.delete OPTS_KEY)
      
      raw_config.each do |k, v|
        case v.class.name
        when 'Hash'
          if v[OPTS_KEY]
            db_profiles << DatabaseProfile.new(k, remove_opts(v), Options.new(v[OPTS_KEY]))
          else
            db_profiles << DatabaseProfile.new(k, v, global_opts)
          end
        when 'Array'
          v = v.reduce(:merge)
          group_opts = Options.new(v.delete(OPTS_KEY) || global_opts.opts, k)
          
          v.each do |db, config|
            if config[OPTS_KEY]
              db_profiles << DatabaseProfile.new(db, remove_opts(config), Options.new(config[OPTS_KEY], k))
            else
              db_profiles << DatabaseProfile.new(db, config, group_opts)
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
end
