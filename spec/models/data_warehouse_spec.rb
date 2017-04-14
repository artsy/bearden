require 'rails_helper'

describe DataWarehouse do
  describe '.reset' do
    context 'with a Postgres error' do
      it 'returns a result with those errors' do
        connection = double(:connection)
        allow(connection).to receive(:exec).and_raise PG::Error
        allow(Redshift).to receive(:connect).and_yield connection
        result = DataWarehouse.reset(nil)
        expect(result.errors).to eq 'PG::Error: PG::Error'
      end
    end

    context 'when everything goes well' do
      it 'returns a successful result with counts' do
        result = DataWarehouse::Result.new
        connection = double(:connection)
        before_count_result = double(:count_result, values: ['0'])
        after_count_result = double(:count_result, values: ['1'])
        allow(connection).to receive(:exec).and_return(
          before_count_result,
          nil,
          nil,
          after_count_result
        )

        DataWarehouse.new(['s3:/path/to.csv'], result, connection).reset

        expect(result).to be_success
        expect(result.before_count).to eq 0
        expect(result.after_count).to eq 1
      end
    end
  end
end
