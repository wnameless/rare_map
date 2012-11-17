# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'jeweler'
require './lib/rare_map/version.rb'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rare_map"
  gem.homepage = "http://github.com/wnameless/rare_map"
  gem.license = "Apache License, Version 2.0"
  gem.summary = "rare_map-#{gem.version}"
  gem.description = %Q{Relational db to ActiveREcord models MAPper}
  gem.email = "wnameless@gmail.com"
  gem.authors = ["Wei-Ming Wu"]
  # dependencies defined in Gemfile
  gem.files = Dir.glob('lib/**/*.rb')
  gem.version = RareMap::Version::STRING
  gem.executables = ['raremap']
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
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
