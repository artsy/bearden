require 'rails_helper'

describe ImportResult do
  describe '#name' do
    it 'returns the name' do
      import = Fabricate :import
      import_result = ImportResult.new(import)
      expected_name = "#{import.source.name} import ##{import.id}"
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
end
