module RareMap
  module RailsLocator
   def locate_rails_root(path = '.', depth = 5)
      rails_dirs = %w(app config db lib log public)
      
      depth.times do |level|
        found = true
        paths = [path]
        
        level.times { paths << '..' }
        
        rails_dirs.each do |dir|
          found = false unless Dir.exist? File.join(*(paths + [dir]))
        end
        
        return File.absolute_path(File.join(*paths)) if found
      end
      
      nil
    end
  end
end