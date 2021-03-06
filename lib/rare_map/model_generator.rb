require 'active_support/inflector'

module RareMap
  # RareMap::ModelGenerator converts an Array of Model into ActiveRecord files.
  # @author Wei-Ming Wu
  module ModelGenerator
    # Creaetes ActiveRecord files by given Model(s) under app/models directory.
    def generate_models(models, root = '.')
      root ||= '.'
      path = File.join(root, 'app', 'models')
      Dir.mkdir File.join(root, 'app') unless Dir.exist? File.join(root, 'app')
      Dir.mkdir path unless Dir.exist? path
      
      group_db2conn = generate_connection_models(models, path)
      
      models.each do |model|
        output = ''
        output <<
        "module #{model.group.camelize}\n" <<
        "  class #{model.classify} < #{group_db2conn[[model.group, model.db_name]]}\n" <<
        "    self.table_name = '#{model.table.name}'\n" <<
        "    self.inheritance_column = 'ruby_type'\n" <<
        "    #{ "self.primary_key = '#{model.table.primary_key}'\n" if model.table.primary_key }\n" <<
        "    if ActiveRecord::VERSION::STRING < '4.0.0' || defined?(ProtectedAttributes)\n" <<
        "      attr_accessible #{model.table.columns.map { |col| ":#{col.name}" }.join(', ')}\n" <<
        "    end\n\n"
        
        belongs_to = model.relations.select { |rel| rel.type == :belongs_to }
        unless belongs_to.empty?
          output << belongs_to
            .map { |rel| "    belongs_to :#{rel.table.pluralize.singularize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }
            .join("\n") << "\n"
        end
        
        has_one = model.relations.select { |rel| rel.type == :has_one }
        unless has_one.empty?
          output << has_one
            .map { |rel| "    has_one :#{rel.table.pluralize.singularize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }
            .join("\n") << "\n"
        end
        
        has_many = model.relations.select { |rel| rel.type == :has_many }
        unless has_many.empty?
          output << has_many
            .map { |rel| "    has_many :#{rel.table.pluralize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }
            .join("\n") << "\n"
        end
        
        has_many_through = model.relations.select { |rel| rel.type == :has_many_through }
        unless has_many_through.empty?
          output << has_many_through
            .map { |rel| "    has_many :#{rel.table.pluralize}#{"_by_#{rel.through}, :source => :#{rel.table.pluralize.singularize}" if has_many_through.count { |hmt| hmt.table == rel.table } > 1 || has_many.count { |hm| hm.table == rel.table } > 0 }, :through => :#{rel.through.pluralize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }
            .join("\n") << "\n"
        end
        
        output << "  end\n"
        output << 'end'
        
        Dir.mkdir File.join(path, "#{model.group.underscore}") unless Dir.exist? File.join(path, "#{model.group}")
        f = File.new File.join(path, "#{model.group.underscore}", "#{model.classify.underscore}.rb"), 'w'
        f.write output
        f.close
      end
      
      models
    end
    
    private
    
    def classify_by_table(table, model, models)
      if model.group?
        model = models.find { |m| m.table.name == table &&
                                  m.group      == model.group }
      else
        model = models.find { |m| m.table.name == table &&
                                  m.group      == model.group &&
                                  m.db_name    == model.db_name }
      end
      
      model.classify
    end
    
    def generate_connection_models(models, path)
      group_db2conn = {}
      
      group2connection = Hash[models.map { |model| [[model.group, model.db_name], [model.connection, model.table.name]] }]
      group2connection.each do |(group, db_name), (connection, table_name)|
        model = "#{db_name}".camelize + 'Base'
        
        output = ''
        output <<
        "module #{group.camelize}\n" <<
        "  class #{model} < ActiveRecord::Base\n" <<
        "    establish_connection #{connection.map { |k, v| ":#{k} => #{v.inspect}" }.join(', ')}\n" <<
        "    self.table_name = '#{table_name}'\n" <<
        "  end\n" <<
        'end'
        
        
        Dir.mkdir File.join(path, "#{group.underscore}") unless Dir.exist? File.join(path, "#{group}")
        f = File.new File.join(path, "#{group.underscore}", "#{model.underscore}.rb"), 'w'
        f.write output
        f.close
        
        group_db2conn[[group, db_name]] = model
      end
      
      group_db2conn
    end
  end
end