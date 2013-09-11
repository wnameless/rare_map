require 'test_helper'
require 'rare_map/config_loader'

class ConfigLoaderTest < Test::Unit::TestCase
  MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
  
  include RareMap::ConfigLoader
  include RareMap::Errors
  
  def test_load_config_error
    assert_raise ConfigNotFoundError do
      load_config 'no_file'
    end
  end
end