require 'rare_map/rails_locator'
require 'rare_map/schema_to_hash_mapping'

module DatabaseToSchemaBuilder
  
  def self.build
    file = File.open(RailsLocator.locate + 'config/database.yml') { |f| f.read }
    database = file.split("\n").select do |line|
      line.match(/^[a-z]+/) && line != 'development:' && line != 'test:' && line != 'production:'
    end
    database.map! { |db| db.delete(':') }
    
    database_hash = Hash.new { |hash, key| hash[key] = [] }
    database.each { |db| database_hash[db.split('_').first.to_sym] << { :dbname => db } }
    
    database_hash.each do |group, dbs|
      dbs.each do |db|
        puts "db:schema:dump RAILS_ENV=#{db[:dbname]}"
        system "rake db:schema:dump RAILS_ENV=#{db[:dbname]}"
        schema = File.open(RailsLocator.locate + 'db/schema.rb') { |f| f.read }
        db[:schema] = SchemaToHashMapping.convert(schema.split("\n"))
      end
    end
    database_hash
  end
  
end