module SchemaPlusMultischema
  module ActiveRecord
    module ConnectionAdapters
      module PostgresqlAdapter

        # Returns the list of all tables in the schema search path or a specified schema.
        def tables(name = nil)
          select_tablenames_with_schemas <<-SQL
            SELECT schemaname, tablename
            FROM pg_tables
            WHERE schemaname = ANY(current_schemas(false))
          SQL
        end

        def select_tablenames_with_schemas(arel)
          arel, binds = binds_from_relation arel, []
          sql = to_sql(arel, binds)
          execute_and_clear(sql, 'SCHEMA', binds) do |result|
            if result.nfields > 0
              rows = result.column_values(0).count
              (0..(rows - 1)).map{ |i| "#{result.column_values(0)[i]}.#{result.column_values(1)[i]}" }
            else
              []
            end
          end
        end
      end
    end
  end
end
