require 'test_helper'

class RareMapTest < Test::Unit::TestCase
  def setup
    @mapper = RareMap::Mapper.new
  end
  
  def test_constructor
    assert @mapper.kind_of? RareMap::Mapper
  end
end
