require 'rubygems'
require 'bundler'
require 'json'
require 'simplecov'
SimpleCov.start
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rare_map'

class Test::Unit::TestCase
  def run_setup_hooks ; end
  def run_teardown_hooks ; end
end

MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL = nil