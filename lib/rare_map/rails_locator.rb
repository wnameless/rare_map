module RareMap
  # RareMap::RailsLocator locates the root of a rails application from any
  # where inside it.
  # @author Wei-Ming Wu
  module RailsLocator
   # Finds the root of a rails application.
   #
   # @param [String] path the location where start to search
   # @param [Integer] depth the max levels of folders to search
   # @return [String, nil] the root of a rails application
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