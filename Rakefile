# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/rare_map/version.rb'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rare_map"
  gem.homepage = "http://github.com/wnameless/rare_map"
  gem.license = "Apache License, Version 2.0"
  gem.version = RareMap::Version::STRING
  gem.summary = "rare_map-#{gem.version}"
  gem.description = %Q{Relational db to ActiveREcord models MAPper}
  gem.email = "wnameless@gmail.com"
  gem.authors = ["Wei-Ming Wu"]
  gem.files = Dir.glob('lib/**/*.rb')
  gem.executables = ['raremap']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rare_map #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
