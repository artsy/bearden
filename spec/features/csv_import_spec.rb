require 'rails_helper'

feature 'CSV Import' do
  scenario 'Import one complete gallery' do
    csv_file = 'spec/fixtures/one_complete_gallery.csv'

    website = 'http://example.com'
    results = [{ status: 200, content: website }]
    resolver = double(:resolver, results: results, resolved_url: website)
    expect(WebsiteResolver).to receive(:resolve).and_return(resolver)

    allow_any_instance_of(S3Uploader).to receive(:store!)
    allow_any_instance_of(Fog::Storage::AWS::GetObjectUrl)
      .to receive(:get_object_url).and_return(csv_file)

    data = File.read(csv_file)
    res = double(:response, body: data)
    expect(Faraday).to receive(:get).and_return(res)

    Fabricate :tag, name: 'design'
    Fabricate :tag, name: 'modern'
    source = Fabricate :source, name: 'Factual'

    visit '/imports/new'

    select source.name, from: 'Source'
    attach_file('import_file_identifier', csv_file)
    fill_in 'Description', with: 'Monthly Data Import'

    click_button 'Create'

    expect(source.imports.count).to eq 1
    import = source.imports.first
    expect(page).to have_text "Factual import: #{import.id} - finished"
    expect(page).to have_text import.description

    actual_counts = page.all('td + td').map(&:text)
    expected_counts = %w[1 0 0 1]
    expect(actual_counts).to eq expected_counts
  end
end
