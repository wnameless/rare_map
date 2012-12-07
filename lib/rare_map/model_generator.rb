require 'active_support/inflector'

module RareMap
  module ModelGenerator
    def generate_models(models, root = './')
      root ||= './'
      path = root + 'app/models/'
      
      models.each do |model|
        output = ''
        output <<
        "class #{model.classify} < ActiveRecord::Base\n" <<
        "  establish_connection #{model.connection.map { |k, v| ":#{k} => #{v.inspect}" }.join(', ')}\n" <<
        "  self.table_name = '#{model.table.name}'\n" <<
        "  self.inheritance_column = 'ruby_type'\n" <<
        "  #{ "self.primary_key = '#{model.table.primary_key}'\n" if model.table.primary_key }\n" <<
        "  attr_accessible #{model.table.columns.map { |col| ":#{col.name}" }.join(', ')}\n\n"
        
        belongs_to = model.relations.select { |rel| rel.type == :belongs_to }
        unless belongs_to.empty?
          output << belongs_to.
            map { |rel| "  belongs_to :#{rel.table.pluralize.singularize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }.
            join("\n") << "\n"
        end
        
        has_one = model.relations.select { |rel| rel.type == :has_one }
        unless has_one.empty?
          output << has_one.
            map { |rel| "  has_one :#{rel.table.pluralize.singularize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }.
            join("\n") << "\n"
        end
        
        has_many = model.relations.select { |rel| rel.type == :has_many }
        unless has_many.empty?
          output << has_many.
            map { |rel| "  has_many :#{rel.table.pluralize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }.
            join("\n") << "\n"
        end
        
        has_many_through = model.relations.select { |rel| rel.type == :has_many_through }
        unless has_many_through.empty?
          output << has_many_through.
            map { |rel| "  has_many :#{rel.table.pluralize}#{"_by_#{rel.through}, :source => :#{rel.table.pluralize.singularize}" if has_many_through.count { |hmt| hmt.table == rel.table } > 1 || has_many.count { |hm| hm.table == rel.table } > 0 }, :through => :#{rel.through.pluralize}, :foreign_key => '#{rel.foreign_key}', :class_name => '#{classify_by_table(rel.table, model, models)}'" }.
            join("\n") << "\n"
        end
        
        output << 'end'
        
        Dir.mkdir root + 'app' unless Dir.exist? root + 'app'
        Dir.mkdir path unless Dir.exist? path
        Dir.mkdir path + "#{model.group}" unless Dir.exist? path + "#{model.group}"
        f = File.new(path + "#{model.group}/#{model.classify.underscore}.rb", 'w')
        f.write output
        f.close
      end
      
      models
    end
    
    private
    def classify_by_table(table, model, models)
      model = models.find { |m| m.table.name == table &&
                                m.group      == model.group &&
                                m.default_id == model.default_id }
      model.classify
    end
  end
end