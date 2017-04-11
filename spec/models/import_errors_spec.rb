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

    context 'with rankable errors' do
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
          email: { content: [{ error: :invalid, value: email }] },
          website: { content: [
            { error: :invalid, value: website },
            { error: :taken, value: website }
          ] }
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

        rows = [[email, website, exception, error_messages]]

        filename = "errors/#{import.id}.csv"
        headers = %w[email website exception error_details]

        options = {
          rows: rows,
          filename: filename,
          headers: headers,
          acl: S3CsvExport::PUBLIC
        }

        expect(S3CsvExport).to receive(:create).with(options)
        ImportErrors.export(import)
      end
    end

    context 'with tag errors' do
      it 'exports those errors to S3 in CSV format' do
        import = Fabricate :import
        exception = 'RawInputChanges::InvalidData'

        tag_names = %w[design]

        data = {
          tag_names: tag_names
        }

        error_details = {
          tags: "all tags could not be applied: #{tag_names}"
        }

        Fabricate(
          :raw_input,
          data: data,
          error_details: error_details,
          exception: exception,
          import: import,
          state: RawInput::ERROR
        )

        error_message = 'all tags could not be applied'
        rows = [[tag_names, exception, error_message]]
        filename = "errors/#{import.id}.csv"
        headers = %w[tag_names exception error_details]

        options = {
          rows: rows,
          filename: filename,
          headers: headers,
          acl: S3CsvExport::PUBLIC
        }

        expect(S3CsvExport).to receive(:create).with(options)
        ImportErrors.export(import)
      end
    end
  end
end
