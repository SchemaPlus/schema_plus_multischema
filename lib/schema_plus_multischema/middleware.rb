module SchemaPlusMultischema
  module Middleware

    module PostgreSQL

      module Schema
        module Tables

          def implement(env)
            env.tables += select_tablenames_with_schemas env.connection, <<-SQL
            SELECT schemaname, tablename
            FROM pg_tables
            WHERE schemaname = ANY(current_schemas(false))
            SQL
          end

          private

          def select_tablenames_with_schemas(connection, arel)
            arel, binds = connection.send :binds_from_relation, arel, []
            sql = connection.to_sql(arel, binds)
            connection.send :execute_and_clear, sql, 'SCHEMA', binds do |result|
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
end
