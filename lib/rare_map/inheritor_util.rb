require 'rare_map/rails_locator'

module InheritorUtil
  
  def self.to_class_name(name)
    name.to_s.split('_').map { |word| word.capitalize }.join
  end
  
  def self.remove_underline_between_numbers(line)
    line = line.to_s
    md = line.match(/(\d+)(_)(\d+)/)
    md.size.times { line.gsub!(/(\d+)_(\d+)/, '\1\2') } unless md.nil?
    line.gsub!(/([a-zA-Z])(_)(\d)/, '\1\3')
    line.to_sym
  end
  
  def self.write_model_file(file_name, content, group_name)
    write_file(file_name, content, group_name, 'models')
  end
  
  def self.write_controller_file(file_name, content, group_name)
    write_file(file_name, content, group_name, 'controllers')
  end
  
  def self.complex_flatten(node, flatAry = [])
    if node.kind_of?(Array)
      node.map { |leaf| complex_flatten(leaf, flatAry) }
    elsif node.kind_of?(Hash)
      node.each do |key, val|
        flatAry << key
        complex_flatten(val, flatAry)
      end
    else
      flatAry << node
    end
    flatAry
  end
  
  
  private
  
  
  def self.write_file(file_name, content, group_name, mvc)
    Dir.mkdir(RailsLocator.locate + "app/#{mvc}/#{group_name}") unless Dir.exist?(RailsLocator.locate + "app/#{mvc}/#{group_name}")
    f = File.new(RailsLocator.locate + "app/#{mvc}/#{group_name}/#{group_name}_#{remove_underline_between_numbers(file_name)}.rb", 'w')
    f.write(content)
    f.close
  end
  
end