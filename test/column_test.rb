require 'test_helper'
require 'rare_map/column'

class ColumnTest < Test::Unit::TestCase
  def setup
    @column = RareMap::Column.new 'col1', 'integer'
  end
  
  def test_constructor
    assert @column.kind_of? RareMap::Column
  end
  
  def test_properties
    assert_equal 'col1', @column.name
    assert_equal 'integer', @column.type
  end
  
  def test_unique?
    assert_equal false, @column.unique?
    @column.unique = true
    assert @column.unique?
  end
  
  def test_foreign_key?
    assert_equal false, @column.foreign_key?
    @column.ref_table = 'table1'
    assert @column.foreign_key?
  end
end