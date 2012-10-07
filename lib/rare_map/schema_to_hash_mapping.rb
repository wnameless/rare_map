module SchemaToHashMapping
  
  def self.convert(schema)
    schema_hash = {}
    table_name_sym = :Blank
    
    schema.each do |line|
      case line.strip!
      when /^create_table/
        table_name_sym = filter_table_name_sym(line)
        schema_hash[table_name_sym] = {}
        if line.match(/:primary_key\s*=>\s*"[^"]+",/)
          schema_hash[table_name_sym][:primary_key] = line.match(/:primary_key\s*=>\s*"[^"]+",/).to_s.delete('",').split(/\s+/)[2].to_sym
        end
      when /^t\./
        column_name_sym = filter_column_name_sym(line)
        column_type_sym = filter_column_type_sym(line)
        schema_hash[table_name_sym][column_name_sym] ||= {}
        schema_hash[table_name_sym][column_name_sym][:type] = table_name_sym
        schema_hash[table_name_sym][column_name_sym][:unique] = false
      when /^add_index.*:unique\s*=>\s*true/
        uniqueColumns = filter_unique_columns(line)
        uniqueColumns.each do |column|
          schema_hash[table_name_sym][column][:unique] = true
        end
      end
    end
    
    return schema_hash
  end
  
  
  private
  
  
  def self.filter_unique_columns(line)
    cols = line.match(/\[[^\]]*\]/).to_s.delete('"[],').split(/\s+/).map { |col| col.to_sym }
    cols.size == 1 ? cols : []
  end
  
  def self.filter_table_name_sym(line)
    line.delete('",').split(/\s+/)[1].to_sym
  end
  
  def self.filter_column_name_sym(line)
    line.delete('",').split(/\s+/)[1].to_sym
  end
  
  def self.filter_column_type_sym(line)
    line.delete('",').split(/\s+/)[0][2 .. -1].to_sym
  end
  
end