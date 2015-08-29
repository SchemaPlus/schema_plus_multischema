# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schema_plus_multischema/version'

Gem::Specification.new do |gem|
  gem.name          = "schema_plus_multischema"
  gem.version       = SchemaPlusMultischema::VERSION
  gem.authors       = ["Stenver Jerkku"]
  gem.email         = ["stenver1010@gmail.com"]
  gem.summary       = %q{Adds support for multiple schemas in activerecord when using Postgres}
  gem.homepage      = "https://github.com/SchemaPlus/schema_plus_multischema"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activerecord", "~> 4.2"
  gem.add_dependency "schema_plus_core", "~> 0.5"

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "schema_dev", "~> 3.5", ">= 3.5.1"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "simplecov-gem-profile"
  gem.add_development_dependency "schema_plus_foreign_keys"
end
