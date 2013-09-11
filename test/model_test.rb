require 'test_helper'
require 'rare_map/model'
require 'rare_map/table'

class ModelTest < Test::Unit::TestCase
  def setup
    @connection = { :adapter => "oracle_enhanced", :host => "192.168.1.177", :port => 1521, :database => "labora", :username => "csis", :password => "csis1111" }
    @Table = RareMap::Table.new 'table1'
    @model = RareMap::Model.new 'main', @connection, @Table
  end
  
  def test_constructor
    assert @model.kind_of? RareMap::Model
  end
  
  def test_properties
    assert_equal 'main', @model.db_name
    assert_equal @connection, @model.connection
    assert_equal @Table, @model.table
    assert_equal 'default', @model.group
    @model = RareMap::Model.new 'main', @connection, @Table, 'group1'
    assert_equal 'group1', @model.group
  end
  
  def test_group?
    assert_equal false, @model.group?
    @model = RareMap::Model.new 'main', @connection, @Table, 'group1'
    assert @model.group?
  end
  
  def test_group
    assert_equal 'default', @model.group
    @model = RareMap::Model.new 'main', @connection, @Table, 'group1'
    assert_equal 'group1', @model.group
  end
  
  def test_classify
    assert_equal 'Table1', @model.classify
  end
end