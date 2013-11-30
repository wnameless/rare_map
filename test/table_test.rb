require 'test_helper'
require 'rare_map/table'
require 'rare_map/column'
require 'active_support/inflector'

class TableTest < Test::Unit::TestCase
  def setup
    @Table = RareMap::Table.new 'table1'
  end
  
  def test_constructor
    assert @Table.kind_of? RareMap::Table
  end
  
  def test_properties
    assert_equal 'table1', @Table.name
    assert_equal true, @Table.id
    assert_equal 'id', @Table.primary_key
    assert_equal 'id', @Table.fk_suffix
    assert_equal [], @Table.columns
  end
  
  def test_primary_key
    assert_equal 'id', @Table.primary_key
    @Table.primary_key = 'id2'
    assert_equal 'id2', @Table.primary_key
    @Table = RareMap::Table.new 'table1', id: false
    @Table.columns = [RareMap::Column.new('table1id', 'integer', unique: true)]
    assert_equal 'table1id', @Table.primary_key
    @Table.columns = [RareMap::Column.new('table1sid', 'integer', unique: true)]
    assert_equal 'table1sid', @Table.primary_key
  end
  
  def test_singularize
    assert_equal 'table1'.pluralize.singularize, @Table.singularize
  end
  
  def test_pluralize
    assert_equal 'table1'.pluralize, @Table.pluralize
  end
  
  def test_match_foreign_key
    assert_equal 'table1', @Table.match_foreign_key(RareMap::Column.new('table1_id', 'integer'))
    assert_equal nil, @Table.match_foreign_key(RareMap::Column.new('table2_id', 'integer'))
  end
  
  def test_match_foreign_key_case_insensitively
     assert_equal 'table1', @Table.match_foreign_key(RareMap::Column.new('Table1_ID', 'integer'))
  end
  
  def test_match_foreign_key_by_primary_key
    assert_equal 'table1', @Table.match_foreign_key_by_primary_key('table1_id')
    assert_equal nil, @Table.match_foreign_key_by_primary_key('table2_id')
  end
  
  def test_match_foreign_key_by_primary_key_case_insensitively
    assert_equal 'table1', @Table.match_foreign_key_by_primary_key('Table1_ID')
  end
end