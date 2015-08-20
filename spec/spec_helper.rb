require 'simplecov'
require 'simplecov-gem-profile'
require 'pry'
SimpleCov.start "gem"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'active_record'
require 'schema_plus_multischema'
require 'schema_dev/rspec'
require 'schema_plus_foreign_keys'

SchemaDev::Rspec.setup

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.warnings = true
end


SimpleCov.command_name "[ruby#{RUBY_VERSION}-activerecord#{::ActiveRecord.version}-#{ActiveRecord::Base.connection.adapter_name}]"
