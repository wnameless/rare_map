module RareMap
  module RailsLocator
   def locate_rails_root(depth = 5)
      rails_dirs = ['app', 'config', 'db', 'lib', 'log', 'public']
      
      depth.times do |level|
        found = true
        path = ''
        
        level.times { path << '../' }
        
        rails_dirs.each do |dir|
          found = false unless Dir.exist?(path + dir)
        end
        
        return path if found
      end
      
      nil
    end
  end
end