require 'test_helper'
require 'rare_map/config_loader'

class ConfigLoaderTest < Test::Unit::TestCase
  include RareMap::ConfigLoader
  include RareMap::Errors
  
  def test_load_config_error
    assert_raise ConfigNotFoundError do
      load_config 'no_file'
    end
  end
end