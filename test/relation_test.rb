require 'test_helper'
require 'rare_map/relation'

class RelationTest < Test::Unit::TestCase
  MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
  
  include RareMap::Errors
  
  def setup
    @relation = RareMap::Relation.new :has_one, 'fk1', 'table1'
  end
  
  def test_constructor
    assert @relation.kind_of? RareMap::Relation
  end
  
  def test_constructor_error
    assert_raise RelationNotDefinedError do
      RareMap::Relation.new :has_two, 'fk1', 'table1'
    end
  end
  
  def test_properties
    assert_equal :has_one, @relation.type
    assert_equal 'fk1', @relation.foreign_key
    assert_equal 'table1', @relation.table
    assert_equal nil, @relation.through
    @relation = RareMap::Relation.new :has_one, 'fk1', 'table1', 'table2'
    assert_equal 'table2', @relation.through
  end
end