require 'spec_helper'

describe 'Schema dump' do
  let(:connection) { ActiveRecord::Base.connection }

  around(:each) do |example|
    with_schemas %w[first second] do
      example.run
    end
  end

  context 'with a table that is created without a schema prefix' do
    before(:each) do
      schema_definitions do
        create_table 'no_schema_prefix'
      end
    end
    it 'includes schema prefix in dump' do
      expect(dump_schema).to include('create_table "first.no_schema_prefix"')
    end
  end

  context 'tables with same name in different schemas' do
    before(:each) do 
      schema_definitions do
        create_table 'first.dogs'
        create_table 'second.dogs'
      end
    end

    it 'includes both tables with schema prefixes' do
      expect(dump_schema).to include('create_table "first.dogs"')
      expect(dump_schema).to include('create_table "second.dogs"')
    end

    context 'with schema_plus_foreign_keys support' do
      before(:each) do
        schema_definitions do
          create_table 'first.owners' do |t|
            t.integer :dog_id, null: false, references: 'second.dogs'
          end
        end
      end

      it 'includes foreign key references with schema prefixes' do
        expect(dump_schema).to include('foreign_key: {references: "second.dogs", name: "fk_first_owners_dog_id"')
      end
    end
  end

  private

  def dump_schema
    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end

end
