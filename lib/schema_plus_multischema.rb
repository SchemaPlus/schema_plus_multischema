require 'schema_plus/core'

require_relative 'schema_plus_multischema/version'
require_relative 'schema_plus_multischema/active_record/connection_adapters/postgresql_adapter'

module SchemaPlusMultischema
  module ActiveRecord
  end
end

SchemaMonkey.register SchemaPlusMultischema
