require 'rails_helper'

describe Organization do
  it 'has multiple locations' do
    organization = Fabricate :organization
    Fabricate.times 2, :location, organization: organization
    expect(organization.locations.count).to eql 2
  end

  context 'when records are created and updated' do
    it 'raises an error when PaperTrail.whodunnit is nil' do
      PaperTrail.whodunnit = nil
      expect { Fabricate :organization }.to raise_error(
        ActiveRecord::StatementInvalid
      )
    end
  end

  context '#contributing_sources' do
    context 'with a single source' do
      it 'responds with a single source name' do
        source = Fabricate :source
        import = Fabricate(
          :import,
          source: source,
          transformer: CsvTransformer
        )

        org = nil

        PaperTrail.track_changes_with(import) do
          org = Fabricate :organization
          org.emails.create! content: 'foo@mail'
          org.locations.create! content: 'Testing Way, Specvill'
          org.organization_names.create! content: 'Foo 2'
          org.tags.create! name: 'Bar tag'
          org.phone_numbers.create! content: '555-884-2001'
        end

        sources = org.contributing_sources
        expect(sources).to eq [source]
      end
    end

    context 'with multiple and different sources' do
      it 'responds with an array of their unique source names' do
        source1 = Fabricate :source
        source2 = Fabricate :source
        source3 = Fabricate :source

        import1 = Fabricate(
          :import,
          source: source1,
          transformer: CsvTransformer
        )

        import2 = Fabricate(
          :import,
          source: source2,
          transformer: CsvTransformer
        )

        import3 = Fabricate(
          :import,
          source: source3,
          transformer: CsvTransformer
        )

        org = nil

        PaperTrail.track_changes_with(import1) do
          org = Fabricate :organization
        end

        PaperTrail.track_changes_with(import2) do
          org.emails.create! content: 'foo@mail'
          org.locations.create! content: 'Testing Way, Specvill'
          org.organization_names.create! content: 'Foo 2'
          org.tags.create! name: 'Bar tag'
          org.phone_numbers.create! content: '555-884-2001'
        end

        PaperTrail.track_changes_with(import3) do
          org.emails.create! content: 'bar@mail'
          org.locations.create! content: 'Testing Way, Specvill'
          org.organization_names.create! content: 'Foo 3'
          org.tags.create! name: 'Bar tag'
          org.phone_numbers.create! content: '555-884-2001'
        end

        sources = org.contributing_sources
        expect(sources.count).to eq 3
        expect(sources).to match_array([source1, source2, source3])
      end
    end
  end
end
