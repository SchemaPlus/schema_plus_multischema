require 'spec_helper'

describe 'tables' do

  let(:connection) { ActiveRecord::Base.connection }

  context "with multiple schemas" do

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
      it 'includes schema prefix in table name' do
        expect(connection.tables).to eq %w[first.no_schema_prefix]
      end
    end

    context 'with tables with same name in different schemas' do
      before(:each) do 
        schema_definitions do
          create_table 'first.dogs'
          create_table 'second.dogs'
        end
      end

      it 'includes schema prefix in table names' do
        expect(connection.tables.sort).to eq %w[first.dogs second.dogs]
      end
    end

  end

  context "without multiple schemas" do
    before(:each) do
      schema_definitions do
        create_table 'dogs'
      end
    end

    it 'does not include schema_prefix in table names' do
        expect(connection.tables).to eq %w[dogs]
    end
  end

end
