require 'truncation_helper'
require 'open3'

describe 'Import rake task', task: true do
  let(:command) { "TEST_JOB_ADAPTER=inline RAILS_ENV=test rake import_csv#{arguments}" } # rubocop:disable Metrics/LineLength

  context 'with no arguments' do
    let(:arguments) { '' }

    it 'returns the valid header row' do
      headers = CsvTransformer.allowed_headers.join("\n")
      stdout, status = Open3.capture2 command
      expect(stdout).to eq "allowed headers:\n#{headers}\n"
      expect(status.exitstatus).to eq 0
    end
  end

  context 'with only one argument' do
    let(:arguments) { '[arg]' }

    it 'returns an error message' do
      stderr, status = Open3.capture2e command
      expect(stderr).to eq "Please specify both a Source name and URI.\n"
      expect(status.exitstatus).to eq 1
    end
  end

  context 'with an invalid Source name' do
    let(:arguments) { '[InvalidSource,http://example.com/invalid.csv]' }

    it 'returns an error message' do
      stderr, status = Open3.capture2e command
      expect(stderr).to eq "Source not found.\n"
      expect(status.exitstatus).to eq 1
    end
  end

  context 'with an invalid uri' do
    let(:arguments) { '[Example,http://example.com/invalid.csv]' }

    it 'returns an error message' do
      Fabricate :source, name: 'Example'
      stderr, status = Open3.capture2e command
      expect(stderr).to eq "URI could not be opened.\n"
      expect(status.exitstatus).to eq 1
    end
  end

  context 'with a valid Source name and uri' do
    let(:arguments) { '[Example,spec/fixtures/one_complete_gallery.csv]' }

    it 'imports that csv file using that Source' do
      Fabricate :tag, name: 'design'
      Fabricate :tag, name: 'modern'
      source = Fabricate :source, name: 'Example'
      stdout, status = Open3.capture2 command
      expect(stdout).to eq "Import ##{source.imports.first.id} created.\n"
      expect(status.exitstatus).to eq 0
      expect(source.imports.count).to eq 1
      import = source.imports.first
      expect(import.raw_inputs.count).to eq 1
      expect(Email.count).to eq 1
      expect(Location.count).to eq 1
      expect(Organization.count).to eq 1
      expect(OrganizationName.count).to eq 1
      expect(OrganizationTag.count).to eq 2
      expect(PhoneNumber.count).to eq 1
      expect(Website.count).to eq 1
    end
  end

  context 'with a csv file that has valid partial information' do
    let(:arguments) { '[Example,spec/fixtures/one_partial_gallery.csv]' }

    it 'imports whatever information the file has for us' do
      source = Fabricate :source, name: 'Example'
      stdout, status = Open3.capture2 command
      expect(stdout).to eq "Import ##{source.imports.first.id} created.\n"
      expect(status.exitstatus).to eq 0
      expect(source.imports.count).to eq 1
      import = source.imports.first
      expect(import.raw_inputs.count).to eq 1
      expect(Email.count).to eq 1
      expect(Location.count).to eq 0
      expect(Organization.count).to eq 1
      expect(OrganizationName.count).to eq 1
      expect(OrganizationTag.count).to eq 0
      expect(PhoneNumber.count).to eq 1
      expect(Website.count).to eq 1
    end
  end
end
