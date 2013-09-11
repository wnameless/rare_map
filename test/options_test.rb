require 'test_helper'
require 'rare_map/options'

class OptionsTest < Test::Unit::TestCase
  MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
  
  def setup
    @options = RareMap::Options.new
    @opts = { 'group'       => 'default',
              'primary_key' => {},
              'foreign_key' => { 'suffix' => nil, 'alias' => {} } }
  end
  
  def test_constructor
    assert @options.kind_of? RareMap::Options
  end
  
  def test_default_options
    assert @options.opts['group'] == 'default'
    assert @options.opts['primary_key'] == {}
    assert @options.opts['foreign_key'] == { 'suffix' => nil, 'alias' => {} }
  end
  
  def test_group?
    assert_equal false, @options.group?
    @options = RareMap::Options.new @opts, 'group1'
    assert @options.group?
  end
  
  def test_group
    assert_equal 'default', @options.group
    @options = RareMap::Options.new @opts, 'group1'
    assert_equal 'group1', @options.group
  end
  
  def test_find_primary_key_by_table
    assert_equal nil, @options.find_primary_key_by_table('table1')
    @opts['primary_key']['table1'] = 'pk1'
    @options = RareMap::Options.new @opts
    assert_equal 'pk1', @options.find_primary_key_by_table('table1')
  end
  
  def test_find_table_by_foreign_key
    assert_equal nil, @options.find_table_by_foreign_key('fk1')
    @opts['foreign_key']['alias']['fk1'] = 'table1'
    @options = RareMap::Options.new @opts
    assert_equal 'table1', @options.find_table_by_foreign_key('fk1')
  end
  
  def test_fk_suffix
    assert_equal nil, @options.fk_suffix
    @opts['foreign_key']['suffix'] = 'suffix'
    @options = RareMap::Options.new @opts
    assert_equal 'suffix', @options.fk_suffix
  end
  
  def test_to_s
    assert_equal @opts.to_s, @options.to_s
  end
end