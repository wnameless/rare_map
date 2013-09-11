require 'test_helper'
require 'rare_map/rails_locator'

class RailsLocatorTest < Test::Unit::TestCase
  include RareMap::RailsLocator
  
  def test_locate_rails_root
    assert_equal nil, locate_rails_root
    assert_equal File.expand_path('rails_root', File.dirname(__FILE__)), locate_rails_root(File.expand_path('rails_root/app', File.dirname(__FILE__)))
    assert_equal nil, locate_rails_root(File.expand_path('rails_root/app', File.dirname(__FILE__)), 0)
  end
end