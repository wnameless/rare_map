require 'test_helper'

class RareMapTest < Test::Unit::TestCase
  MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
  
  def setup
    @mapper = RareMap::Mapper.new
  end
  
  def test_constructor
    assert @mapper.kind_of? RareMap::Mapper
  end
end
