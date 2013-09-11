require 'test_helper'
require 'rare_map/schema_parser'

class SchemaParserTest < Test::Unit::TestCase
  include RareMap::SchemaParser
  
  def setup
    f = File.open(File.join(File.dirname(__FILE__), 'schema.rb'))
    @schema = f.read
    f.close
  end
  
  def test_parse_schema
    tables = parse_schema @schema
    assert_equal 16, tables.size
    table = tables.first
    assert_equal 'access_log', table.name
    assert_equal true, table.id
    assert_equal 'id', table.primary_key
    assert_equal 'id', table.fk_suffix
    assert_equal 5, table.columns.size
    column = table.columns.first
    assert_equal 'url', column.name
    assert_equal 'string', column.type
    assert_equal false, column.unique
    assert_equal nil, column.ref_table
  end
end