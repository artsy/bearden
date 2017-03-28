require 'rails_helper'

describe ImportErrors do
  describe '.export' do
    context 'with no errors' do
      it 'does not export anything' do
        expect(S3CsvExport).to_not receive(:create)
        import = Fabricate :import
        ImportErrors.export(import)
      end
    end

    context 'with some errors' do
      it 'exports those errors to S3 in CSV format' do
        import = Fabricate :import

        email = 'userexample.com'
        website = 'examplecom'

        data = {
          email: email,
          website: website
        }

        exception = 'RawInputChanges::InvalidData'

        error_details = {
          email: { content: [{ error: :invalid }] },
          website: { content: [{ error: :invalid }, { error: :taken }] }
        }

        Fabricate(
          :raw_input,
          data: data,
          error_details: error_details,
          exception: exception,
          import: import,
          state: RawInput::ERROR
        )

        error_messages = 'email invalid, website invalid, website taken'

        rows = [
          [email, website, exception, error_messages]
        ]

        filename = "errors/#{import.id}.csv"
        headers = %w(email website exception error_details)
        expect(S3CsvExport).to receive(:create).with(rows, filename, headers)
        ImportErrors.export(import)
      end
    end
  end
end
