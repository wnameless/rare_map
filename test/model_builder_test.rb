require 'test_helper'
require 'rare_map/config_loader'
require 'rare_map/schema_parser'
require 'rare_map/model_builder'

class ModelBuilderTest < Test::Unit::TestCase
  include RareMap::ConfigLoader, RareMap::SchemaParser, RareMap::ModelBuilder
  
  def setup
    @db_profiles = load_config File.dirname(__FILE__)
    @profile = @db_profiles.first
    f = File.open(File.join(File.dirname(__FILE__), 'schema.rb'))
    @profile.schema = f.read
    f.close
    @profile.tables = parse_schema @profile.schema
  end
  
  def test_build_models
    @models = build_models @db_profiles
    assert_equal 16, @models.size
  end
end