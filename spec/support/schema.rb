def with_schemas(names)
  connection = ActiveRecord::Base.connection
  begin
    previous_schemas = connection.schema_search_path
    names.each do |name|
      connection.execute "CREATE SCHEMA IF NOT EXISTS #{name}"
    end
    connection.schema_search_path = names.join(',')
    yield
  ensure
    drop_all_tables
    names.each do |name|
      connection.execute "DROP SCHEMA IF EXISTS #{name}"
    end
    connection.schema_search_path = previous_schemas
  end
end

def schema_definitions(&block)
  ActiveRecord::Schema.define &block
end

def drop_all_tables
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table table, force: :cascade
  end
end


