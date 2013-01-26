# $:.unshift File.dirname(__FILE__)

require 'rare_map/rails_locator'
require 'rare_map/config_loader'
require 'rare_map/schema_reader'
require 'rare_map/schema_parser'
require 'rare_map/model_builder'
require 'rare_map/model_generator'

module RareMap
  def self.mapping
    Mapper.new.mapping
  end
  
  class Mapper
    include RailsLocator, ConfigLoader, SchemaReader, SchemaParser, ModelBuilder, ModelGenerator
    
    def initialize
      @rails_root = locate_rails_root
    end
    
    def mapping
      @db_profiles = load_config @rails_root ? @rails_root + 'config/' : './'
      @db_profiles.each do |profile|
        profile.schema = read_schema profile
        profile.tables = parse_schema profile.schema
      end
      @models = build_models @db_profiles
      generate_models @models, @rails_root
      if @rails_root
        puts '*****************************************************************************'
        puts '  Add following line to your config/application.rb'
        puts "    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]"
        puts '*****************************************************************************'
        create_initializer
      else
        puts '*****************************************************************************'
        puts '  A demo.rb is generated'
        puts '*****************************************************************************'
        generate_demo unless File.exist?('demo.rb')
      end
      @models
    end
    
    private
    def generate_demo
      f = File.new('demo.rb', 'w')
      f.write "require 'active_record'\n"
      f.write "require 'activerecord-jdbc-adapter' if RUBY_PLATFORM == 'java'\n"
      f.write "Dir[File.dirname(__FILE__) + '/app/models/**/*_base.rb'].each { |file| require file }\n"
      f.write "Dir[File.dirname(__FILE__) + '/app/models/**/*.rb'].each { |file| require file }\n"
      f.close
    end
    
    def create_initializer
      f = File.new(@rails_root + 'config/initializers/rare_map.rb', 'w')
      f.write "bases = []; models = []\n"
      f.write "Dir[Rails.root + 'app/models/**/*.rb'].each do |file|\n"
      f.write "  if file =~ /models\\/[^\\/]+\\/[^\\/]+_base.rb$/\n"
      f.write "    bases << file\n"
      f.write "  elsif file =~ /models\\/[^\\/]+\\/[^\\/]+.rb$/\n"
      f.write "    models << file\n"
      f.write "  end\n"
      f.write "end\n"
      f.write "bases.map { |b| require b }\n"
      f.write "models.map { |m| require m }\n"
      f.close
    end
  end
end

if __FILE__ == $0
  RareMap.mapping
end