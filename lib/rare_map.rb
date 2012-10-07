require 'rare_map/database_to_schema_builder'
require 'rare_map/schema_to_relation_builder'
require 'rare_map/schema_to_model_builder'
require 'rare_map/rails_locator'

class RareMap
  
  def self.mapping(opt = {})
    unless RailsLocator.locate
      $stderr.puts 'Run RareMap under Rails root directory'
      return
    end
    
    info = {}
    
    databases = DatabaseToSchemaBuilder.build
    databases.each do |group_name, tables|  
      foreign_keys = opt[:foreign_key][group_name]
      aliases = opt[:alias][group_name]
      primary_keys = opt[:primary_key][group_name]
      
      schemata = tables.inject({}) { |o, i| o = o.merge(i[:schema]) }
      primary_keys.each do |table, primary_key|
        schemata[table][:primary_key] = primary_key if schemata[table]
      end
      relations = SchemaToRelationBuilder.build(schemata, foreign_keys, aliases)
      SchemaToModelBuilder.build(schemata, relations, group_name, databases)
      
      info[group_name] ||= {}
      info[group_name][:schemata] = schemata
      info[group_name][:relations] = relations
    end
    
    $stdout.puts %{Add following line to your config/application.rb}
    $stdout.puts %{config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]}
    
    info[:databases] = databases
    info
  end
  
end
