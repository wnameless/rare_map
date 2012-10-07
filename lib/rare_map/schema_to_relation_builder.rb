module BelongsTo2HasManyThroughtRelationBuilder
  
  def self.build(belongs_to_hash, has_one_hash, has_many_hash)
    belongs_to_hash = belongs_to_hash.clone
    has_many_through_hash = {}
  
    belongs_to_hash = belongs_to_hash.delete_if { |table, rels| rels.size < 2 }
    belongs_to_hash.each do |table, rels|
      rels.each do |from_table, from_table_key|
        rels.each do |to_table, to_table_key|
          if from_table != to_table
            has_many_through_hash[from_table] ||= []
            rel = [to_table, to_table_key, table]
            has_many_through_hash[from_table] << rel 
          end
        end
      end
    end
    
    final_has_many_through_hash = {}
    has_many_through_hash.each do |table, rels|
      rels.each do |rel|
        if has_many_hash[table] != nil && has_many_hash[table].count { |i| i.first == rel.first } == 0
          final_has_many_through_hash[table] ||= []
          final_has_many_through_hash[table] << rel
        end
      end
    end
    has_many_through_hash = final_has_many_through_hash
    
    final_has_many_through_hash = {}
    has_many_through_hash.each do |table, rels|
      rels.each do |rel|
        if has_one_hash[table] != nil && has_one_hash[table].count { |i| i.first == rel.first } == 0
          final_has_many_through_hash[table] ||= []
          final_has_many_through_hash[table] << rel
        end
      end
    end
    has_many_through_hash = final_has_many_through_hash
    
    final_has_many_through_hash = {}
    has_many_through_hash.each do |table, rels|
      rels.each do |rel|
        if belongs_to_hash[table] != nil && belongs_to_hash[table].count { |i| i.first == rel.first } == 0
          final_has_many_through_hash[table] ||= []
          final_has_many_through_hash[table] << rel
        end
      end
    end
    has_many_through_hash = final_has_many_through_hash
    
    has_many_through_hash
  end
  
end

module SchemaToRelationBuilder
  
  def self.build(schema_hash, relation_mark, alias_hash = {})
    relation_mark ||= '_id'
    has_one_hash = {}; has_many_hash = {}; belongs_to_hash = {}
    
    schema_hash.each do |table_name, table_content|
      table_content.each do |column, type|
        if alias_hash[column] != nil
          belongs_to = alias_hash[column]
          if schema_hash[belongs_to] != nil
            if schema_hash[table_name][column][:unique] == true
              has_one_hash[belongs_to] ||= []
              has_one_hash[belongs_to] << [table_name, column]
            else
              has_many_hash[belongs_to] ||= []
              has_many_hash[belongs_to] << [table_name, column]
            end
            belongs_to_hash[table_name] ||= []
            belongs_to_hash[table_name] << [belongs_to, column]
          end
        elsif column.to_s.match(eval("/#{relation_mark}$/")) && column.to_s[0 .. -(relation_mark.length + 1)].to_sym != table_name
          belongs_to = column.to_s[0 .. -(relation_mark.length + 1)].to_sym
          if schema_hash[belongs_to] != nil
            if schema_hash[table_name][column][:unique] == true
              has_one_hash[belongs_to] ||= []
              has_one_hash[belongs_to] << [table_name, column]
            else
              has_many_hash[belongs_to] ||= []
              has_many_hash[belongs_to] << [table_name, column]
            end
            belongs_to_hash[table_name] ||= []
            belongs_to_hash[table_name] << [belongs_to, column]
          end
        end
      end
    end
    
    has_many_through_hash = BelongsTo2HasManyThroughtRelationBuilder.build(belongs_to_hash, has_one_hash, has_many_hash)
    
    return { :has_one => has_one_hash,
             :has_many => has_many_hash,
             :belongs_to => belongs_to_hash,
             :has_many_through => has_many_through_hash }
  end
  
end