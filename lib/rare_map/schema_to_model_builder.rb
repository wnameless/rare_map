require 'rare_map/inheritor_util'

module SchemaToModelBuilder
  
  def self.build(schema_hash, rel_hash, group_name, database_hash)
    schema_hash.each do |table_name, table_content|
      model_content = generate_header(table_name, schema_hash, group_name, database_hash)
      model_content << generate_attributes_permission(table_content, 'attr_accessible') unless table_content.size == 0
      model_content << generate_relationships(table_name, rel_hash, group_name)
      model_content << generate_footer
      InheritorUtil.write_model_file(table_name, model_content, group_name)
    end
  end
  
  
  private
  
  
  def self.generate_relationships(table_name, rel_hash, group_name)
    return '' if rel_hash.count { |_, hash| hash[table_name] != nil } == 0
    
    has_one_ary = []
    rel_hash[:has_one][table_name].each do |table, foreign_key|
      has_one_ary << "  has_one :#{table}, :foreign_key => '#{foreign_key}', :class_name => '#{group_name.to_s.capitalize}#{InheritorUtil.to_class_name(table)}'"
    end if rel_hash[:has_one][table_name] != nil
    
    has_many_ary = []
    rel_hash[:has_many][table_name].each do |table, foreign_key|
      has_many_ary << "  has_many :#{table}, :foreign_key => '#{foreign_key}', :class_name => '#{group_name.to_s.capitalize}#{InheritorUtil.to_class_name(table)}'"
    end if rel_hash[:has_many][table_name] != nil
    
    belongs_to_ary = []
    rel_hash[:belongs_to][table_name].each do |table, foreign_key|
      belongs_to_ary << "  belongs_to :#{table}, :foreign_key => '#{foreign_key}', :class_name => '#{group_name.to_s.capitalize}#{InheritorUtil.to_class_name(table)}'"
    end if rel_hash[:belongs_to][table_name] != nil
    
    has_many_through_ary = []
    rel_hash[:has_many_through][table_name].each do |table, foreign_key, through|
      has_many_through_ary << "  has_many :#{table}, :foreign_key => '#{foreign_key}', :class_name => '#{group_name.to_s.capitalize}#{InheritorUtil.to_class_name(table)}', :through => :#{through}"
    end if  rel_hash[:has_many_through][table_name] != nil
    
    has_one_ary.join("\n") << "\n" <<
    has_many_ary.join("\n") << "\n" <<
    belongs_to_ary.join("\n") + "\n" <<
    has_many_through_ary.join("\n") << "\n"
  end
  
  def self.generate_attributes_permission(table_content, permission)
    table_content.keys.inject('  ' + permission) { |o, i| o = o + " :#{i}," }[0 .. -2] + "\n"
  end
  
  def self.generate_header(table_name, schema_hash, group_name, database_hash)
    "class #{group_name.to_s.capitalize}#{InheritorUtil.to_class_name(table_name)} < ActiveRecord::Base\n" <<
    "  establish_connection :#{get_connection_name(table_name, group_name, database_hash)}\n" <<
    "  self.table_name = '#{table_name}'\n" <<
    "  self.inheritance_column = 'ruby_type'\n" <<
    "  self.primary_key = '#{check_primary_key(table_name, schema_hash)}'\n"
  end
  
  def self.get_connection_name(table_name, group_name, database_hash)
    database_hash[group_name].each do |db|
      return db[:dbname] unless db[:schema][table_name].nil?
    end
  end
  
  def self.check_primary_key(table_name, schema_hash)
    schema_hash[table_name][:primary_key].nil? ? 'id' : schema_hash[table_name][:primary_key]
  end
  
  def self.generate_footer
    "end\n"
  end
  
end