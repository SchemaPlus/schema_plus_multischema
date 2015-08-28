module SchemaPlusMultischema
  module Middleware

    module PostgreSQL

      module Schema
        module Tables

          def implement(env)
            query = <<-SQL
              SELECT schemaname, tablename
              FROM pg_tables
              WHERE schemaname = ANY(current_schemas(false))
            SQL
            env.tables += env.connection.exec_query(query, 'SCHEMA').map { |row|
              "#{row['schemaname']}.#{row['tablename']}"
            }
          end

        end
      end
    end
  end
end
