require 'rails_helper'

describe OrganizationExportJob do
  describe '#perform' do
    it 'creates a file on S3 and increments the uploaded parts on the Sync' do
      sync = Fabricate :sync, uploaded_parts: 0
      expect(S3CsvExport).to receive(:create)
      OrganizationExportJob.new.perform(sync.id, 1)
      expect(sync.reload.uploaded_parts).to eq 1
    end
  end
end
