require 'active_support/inflector'
require 'rare_map/model'
require 'rare_map/relation'

module RareMap
  module ModelBuilder
    def build_models(db_profiles)
      models = []
      
      db_profiles.each do |db_prof|
        db_prof.tables.each do |table|
          opts = db_prof.options
          set_primary_key_by_options(table, opts)
          set_foreign_keys_by_options(table, opts)
          set_fk_suffix_by_options(table, opts)
          if opts.group?
            models << Model.new(db_prof.name, db_prof.connection, table, opts.group)
          else
            models << Model.new(db_prof.name, db_prof.connection, table, 'default')
          end
        end
      end
      
      build_relations models
      
      models
    end
    
    private
    
    def build_relations(models)
      models.each do |model|
        if model.group?
          group_models = models.select { |m| m.group == model.group }
        else
          group_models = models.select { |m| m.group == model.group && m.db_name == model.db_name }
        end
        
        group_models.each do |gm|
          model.table.columns.each do |col|
            if gm.table.match_foreign_key(col) && model != gm
              model.relations << Relation.new(:belongs_to, col.name, gm.table.name)
              gm.relations << Relation.new(col.unique? ? :has_one : :has_many, col.name, model.table.name)
            end
          end
          
          if gm.table.match_foreign_key_by_primary_key(model.table.primary_key) && model != gm
            model.relations << Relation.new(:belongs_to, model.table.primary_key, gm.table.name)
            gm.relations << Relation.new(:has_one, model.table.primary_key, model.table.name)
          end
        end
      end
      
      models.each do |model|
        model.relations.each do |rel_from|
          model.relations.each do |rel_to|
            if rel_from != rel_to && rel_from.table != rel_to.table &&
              rel_from.type == :belongs_to && rel_to.type == :belongs_to 
               
              if model.group?
                model_from = models.find { |m| m.table.name == rel_from.table &&
                                               m.group      == model.group }
                model_to = models.find { |m| m.table.name == rel_to.table &&
                                             m.group      == model.group }
              else
                model_from = models.find { |m| m.table.name == rel_from.table &&
                                               m.group      == model.group &&
                                               m.db_name    == model.db_name }
                model_to = models.find { |m| m.table.name == rel_to.table &&
                                             m.group      == model.group &&
                                             m.db_name    == model.db_name }
              end
              
              model_from.relations << Relation.new(:has_many_through, rel_to.foreign_key, model_to.table.name, model.table.name)
              model_to.relations << Relation.new(:has_many_through, rel_from.foreign_key, model_from.table.name, model.table.name)
            end
          end
        end
      end
      
      models.each do |model|
        model.relations.uniq! { |rel| "#{rel.type} #{rel.table} #{rel.through}" }
      end
    end
    
    def set_fk_suffix_by_options(table, options)
      table.fk_suffix = options.fk_suffix if options.fk_suffix
    end
    
    def set_foreign_keys_by_options(table, options)
      table.columns.each do |col|
        ref = options.find_table_by_foreign_key col.name
        col.references = ref if ref
      end
    end
    
    def set_primary_key_by_options(table, options)
      pk = options.find_primary_key_by_table table.name
      table.primary_key = pk if pk
    end
  end
end