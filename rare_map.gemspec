lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rare_map/version"
require "date"

Gem::Specification.new do |s|
  s.name = "rare_map"
  s.version = "#{RareMap::VERSION}"
  s.authors = ["Wei-Ming Wu"]
  s.date = "#{Date.today.to_s}"
  s.description = "Relational db to ActiveREcord models MAPper"
  s.email = "wnameless@gmail.com"
  s.homepage = "http://github.com/wnameless/rare_map"
  s.licenses = ["Apache License, Version 2.0"]
  s.require_paths = ["lib"]
  s.summary = "rare_map-#{RareMap::VERSION}"
  
  s.executables = ["raremap"]
  s.files = Dir["{lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency "activerecord", ">= 3.2.0"
  s.add_runtime_dependency "activesupport", ">= 3.2.0"
  
  s.add_development_dependency "simplecov"
  s.add_development_dependency "yard"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
end
