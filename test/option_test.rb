require 'helper'
require 'rare_map/options'

class OptionTest < Test::Unit::TestCase
  MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
  
  def setup
    @options = RareMap::Options.new
  end
  
  def test_constructor
    assert @options.kind_of? RareMap::Options
  end
end