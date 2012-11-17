require 'active_record'

module RareMap
  module SchemaReader
    def read_schema(db_profile)
      conn = db_profile.connection.map { |k, v| v.kind_of?(Integer) ? "'#{k}'=>#{v}" : "'#{k}'=>'#{v}'" }.join(', ')
      if RUBY_PLATFORM == "java"
        %x[jruby -e "require 'active_record'; ActiveRecord::Base.establish_connection(#{conn}); ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection);"]
      else
        %x[ruby -e "require 'active_record'; ActiveRecord::Base.establish_connection(#{conn}); ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection);"]
      end
      # schema = StringIO.new
      # ActiveRecord::Base.establish_connection db_profile.connection
      # ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, schema)
      # schema.close
      # schema.string
    end
  end
end