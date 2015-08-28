module SchemaPlusMultischema
  module Middleware

    module PostgreSQL

      module Schema
        module Tables

          DEFAULT_SCHEMA_SEARCH_PATH = %q{"$user",public}

          def implement(env)
            use_prefix = (env.connection.schema_search_path != DEFAULT_SCHEMA_SEARCH_PATH)
            query = <<-SQL
              SELECT schemaname, tablename
              FROM pg_tables
              WHERE schemaname = ANY(current_schemas(false))
            SQL
            env.tables += env.connection.exec_query(query, 'SCHEMA').map { |row|
              if use_prefix
                "#{row['schemaname']}.#{row['tablename']}"
              else
                row['tablename']
              end
            }
          end

        end
      end
    end
  end
end
