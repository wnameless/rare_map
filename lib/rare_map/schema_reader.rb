require 'active_record'
require 'activerecord-jdbc-adapter' if RUBY_PLATFORM == 'java'

module RareMap
  module SchemaReader
    def read_schema(db_profile)
=begin
      conn = db_profile.connection.map { |k, v| v.kind_of?(Integer) ? "'#{k}'=>#{v}" : "'#{k}'=>'#{v}'" }.join(', ')
      schema = if RUBY_PLATFORM == 'java'
        %x[jruby -e "require 'active_record'; require 'activerecord-jdbc-adapter'; ActiveRecord::Base.establish_connection(#{conn}); ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection);" 2>&1]
      else
        %x[ruby -e "require 'active_record'; ActiveRecord::Base.establish_connection(#{conn}); ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection);" 2>&1]
      end
      detect_errors schema
      schema
=end
      schema = StringIO.new
      ActiveRecord::Base.establish_connection db_profile.connection
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, schema)
      schema.close
      schema.string
    end
    
    def detect_errors(schema)
      if $? != 0
        puts schema
        schema = ''
      end
    end
  end
end