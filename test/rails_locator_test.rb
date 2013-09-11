require 'test_helper'
require 'rare_map/rails_locator'

class RailsLocatorTest < Test::Unit::TestCase
  MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
  
  include RareMap::RailsLocator
  
  def test_locate_rails_root
    assert_equal nil, locate_rails_root
    assert_equal File.expand_path('rails_root', File.dirname(__FILE__)), locate_rails_root(File.expand_path('rails_root/app', File.dirname(__FILE__)))
    assert_equal nil, locate_rails_root(File.expand_path('rails_root/app', File.dirname(__FILE__)), 0)
  end
end