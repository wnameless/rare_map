module RailsLocator
  
 def self.locate(level = 5)
    rails_dirs = ['app', 'config', 'db', 'doc', 'lib']
    
    level.times do |i|
      found = true
      path = ''
      
      i.times { path += '../' }
      
      rails_dirs.each do |dir|
        found = false unless Dir.exist?(path + dir)
      end
      
      return path if found
    end
    
    nil
  end
  
end