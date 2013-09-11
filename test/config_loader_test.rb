require 'test_helper'
require 'rare_map/config_loader'
require 'yaml'

class ConfigLoaderTest < Test::Unit::TestCase
  include RareMap::ConfigLoader
  include RareMap::Errors
  
  def test_load_config
    db_profiles = load_config File.dirname(__FILE__)
    assert_equal 1, db_profiles.size
    db_profile = db_profiles.first
    assert db_profile.kind_of? RareMap::DatabaseProfile
    assert_equal 'main', db_profile.name
    assert_equal YAML.load_file(File.join(File.dirname(__FILE__), 'rare_map.yml'))['sample'][1]['main'], db_profile.connection
    assert_equal 'sample', db_profile.options.group
  end
  
  def test_load_config_simple
    db_profiles = load_config File.dirname(__FILE__), 'rare_map_simple.yml'
    assert_equal 1, db_profiles.size
    db_profile = db_profiles.first
    assert db_profile.kind_of? RareMap::DatabaseProfile
    assert_equal 'main', db_profile.name
    assert_equal YAML.load_file(File.join(File.dirname(__FILE__), 'rare_map_simple.yml'))['main'], db_profile.connection
    assert_equal 'default', db_profile.options.group
  end
  
  def test_load_config_error
    assert_raise ConfigNotFoundError do
      load_config 'no_file'
    end
  end
end