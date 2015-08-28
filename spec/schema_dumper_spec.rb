require 'spec_helper'

describe 'Schema dump' do
  before(:each) do
    ActiveRecord::Schema.define do
      connection.schema_search_path='first,second'
      connection.tables.each do |table| drop_table table, force: :cascade end

      execute <<-SQL
          CREATE SCHEMA IF NOT EXISTS first;
          CREATE TABLE first.dogs
          (
            id INTEGER PRIMARY KEY
          );
      SQL

      execute <<-SQL
          CREATE SCHEMA IF NOT EXISTS second;
          CREATE TABLE second.dogs
          (
            id INTEGER PRIMARY KEY
          );
      SQL

      execute <<-SQL
          CREATE SCHEMA IF NOT EXISTS second;
          CREATE TABLE first.owners
          (
            id INTEGER PRIMARY KEY,
            dog_id INTEGER NOT NULL
          );
          CREATE INDEX fk__first_owners_second_dogs ON first.owners USING btree (dog_id);

          ALTER TABLE ONLY first.owners
              ADD CONSTRAINT fk_first_owners_dog_id FOREIGN KEY (dog_id) REFERENCES second.dogs(id) ON DELETE CASCADE;
      SQL

      execute <<-SQL
          CREATE SCHEMA IF NOT EXISTS second;
          CREATE TABLE no_schema_prefix
          (
            id INTEGER PRIMARY KEY
          );
      SQL
    end
  end

  def dump_schema(opts={})
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = Array.wrap(opts[:ignore]) || []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end

  it 'should dump tables which are created without schema prefix' do
    expect(dump_schema).to include('create_table "first.no_schema_prefix"')
  end

  it 'should dump tables with same names from different schemas' do
    expect(dump_schema).to include('create_table "first.dogs"')
    expect(dump_schema).to include('create_table "second.dogs"')
  end

  context 'when foreign key schema plus gem required' do
    it 'should dump foreign key references with schema names' do
      expect(dump_schema).to include('foreign_key: {references: "second.dogs", name: "fk_first_owners_dog_id"')
    end
  end
end
