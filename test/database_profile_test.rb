require 'test_helper'
require 'rare_map/database_profile'
require 'rare_map/options'

class DatabaseProfileTest < Test::Unit::TestCase
  def setup
    @connection = { adapter: 'sqlite3', database: 'db/test.sqlite3' }
    @options = RareMap::Options.new
    @db_profile = RareMap::DatabaseProfile.new 'profile1', @connection, @options
  end
  
  def test_constructor
    assert @db_profile.kind_of? RareMap::DatabaseProfile
  end
  
  def test_properties
    assert_equal 'profile1', @db_profile.name
    assert_equal @connection, @db_profile.connection
    assert_equal @options, @db_profile.options
    assert_equal nil, @db_profile.schema
    @db_profile.schema = ''
    assert_equal '', @db_profile.schema
    assert_equal [], @db_profile.tables
  end
end