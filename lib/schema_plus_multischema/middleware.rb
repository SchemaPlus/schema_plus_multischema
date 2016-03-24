module SchemaPlusMultischema
  module Middleware

    module PostgreSQL
      DEFAULT_SCHEMA_SEARCH_PATH = %r{"\$user",\s*public}

      module Schema
        module Tables

          def implement(env)
            use_prefix = (env.connection.schema_search_path !~ DEFAULT_SCHEMA_SEARCH_PATH)
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

      module Dumper
        module Initial

          def after(env)
            if (path = env.connection.schema_search_path) !~ DEFAULT_SCHEMA_SEARCH_PATH
              path.split(',').each do |name|
                env.initial << %Q{  connection.execute "CREATE SCHEMA IF NOT EXISTS #{name}"}
              end
              env.initial << %Q{  connection.schema_search_path = #{path.inspect}}
            end
          end

        end
      end
    end
  end
end
