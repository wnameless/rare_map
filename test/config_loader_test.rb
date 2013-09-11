require 'test_helper'
require 'rare_map/config_loader'
require 'rare_map/errors'

class ConfigLoaderTest < Test::Unit::TestCase
  include RareMap::ConfigLoader
  include RareMap::Errors
  
  MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
  
  def test_load_config_error
    load_config 'no_file'
    assert false
  rescue ConfigNotFoundError => e
    assert true
  end
end