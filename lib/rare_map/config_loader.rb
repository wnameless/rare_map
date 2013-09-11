require 'yaml'
require 'rare_map/errors'
require 'rare_map/database_profile'
require 'rare_map/options'

module RareMap
  # RareMap::ConfigLoader translates a rare_map.yml into DatabaseProfile.
  # @author Wei-Ming Wu
  module ConfigLoader
    # The key of rare map options inside a config YAML.
    OPTS_KEY = 'rare_map_opts'
    include Errors
    
    # Translates a rare_map.yaml into an Array of DatabaseProfile.
    #
    # @param [String] path the folder which contains the RareMap config
    # @param [String] file_name the name of the RareMap config
    # @return [Array] an Array of DatabaseProfile
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
          group_opts = Options.new((v.delete(OPTS_KEY) || global_opts.opts).merge(group: k))
          
          v.each do |db, config|
            if config[OPTS_KEY]
              db_profiles << DatabaseProfile.new(db, remove_opts(config), Options.new(config[OPTS_KEY].merge(group: k)))
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
