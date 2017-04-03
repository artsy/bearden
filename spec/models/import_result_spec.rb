require 'rails_helper'

describe ImportResult do
  describe '#name' do
    it 'returns the name' do
      import = Fabricate :import
      import_result = ImportResult.new(import)
      expected_name = "#{import.source.name} import: #{import.id}"
      expect(import_result.name).to eq expected_name
    end
  end

  describe 'result counts' do
    it 'returns the right counts' do
      import = Fabricate :import
      [
        RawInput::CREATED,
        RawInput::UPDATED,
        RawInput::ERROR,
        nil
      ].each do |state|
        Fabricate :raw_input, import: import, state: state
      end
      import_result = ImportResult.new(import)
      expect(import_result.total_count).to eq 4
      expect(import_result.created_count).to eq 1
      expect(import_result.updated_count).to eq 1
      expect(import_result.error_count).to eq 1
    end
  end

  describe '#exported_errors_url' do
    context 'without errors' do
      it 'returns nil' do
        import = Fabricate :import, state: ImportMicroMachine::FINISHED
        import_result = ImportResult.new(import)
        expect(import_result.exported_errors_url).to eq nil
      end
    end

    context 'with errors' do
      context 'but not yet finished' do
        it 'returns nil' do
          import = Fabricate :import, state: ImportMicroMachine::TRANSFORMING
          Fabricate(
            :raw_input,
            import: import,
            state: RawInput::ERROR
          )
          import_result = ImportResult.new(import)
          expect(import_result.exported_errors_url).to eq nil
        end
      end

      context 'with a finished import' do
        it 'returns a url for the exported import errors' do
          import = Fabricate :import, state: ImportMicroMachine::FINISHED
          Fabricate(
            :raw_input,
            import: import,
            state: RawInput::ERROR
          )
          import_result = ImportResult.new(import)
          bucket = Rails.application.secrets.aws_bucket
          s3_url = "https://#{bucket}.s3.amazonaws.com/errors/#{import.id}.csv"
          expect(import_result.exported_errors_url).to eq s3_url
        end
      end
    end
  end
end
