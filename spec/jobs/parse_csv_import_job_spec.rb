require 'rails_helper'

describe ParseCsvImportJob do
  context 'with an encoding that needs to be converted' do
    it 'converts the encoding' do
      import = Fabricate :import
      windows_encoded_data = File.read 'spec/fixtures/windows_encoded.csv'
      expect(Faraday).to receive(:get).and_return(windows_encoded_data)
      ParseCsvImportJob.new.perform(import.id)
      expect(import.raw_inputs.count).to eq 1
    end
  end
end
