require 'rails_helper'

describe Organization do
  it 'defaults to being unknown for in_business' do
    organization = Organization.create
    expect(organization.in_business).to eq Organization::UNKNOWN
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
          source: source
        )
        raw_input = Fabricate :raw_input, import: import

        org = nil

        PaperTrail.track_changes_with(raw_input) do
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

        raw_input1 = Fabricate(
          :raw_input,
          import: Fabricate(:import, source: source1)
        )

        raw_input2 = Fabricate(
          :raw_input,
          import: Fabricate(:import, source: source2)
        )

        raw_input3 = Fabricate(
          :raw_input,
          import: Fabricate(:import, source: source3)
        )

        org = nil

        PaperTrail.track_changes_with(raw_input1) do
          org = Fabricate :organization
        end

        PaperTrail.track_changes_with(raw_input2) do
          org.emails.create! content: 'foo@mail'
          org.locations.create! content: 'Testing Way, Specvill'
          org.organization_names.create! content: 'Foo 2'
          org.tags.create! name: 'Bar tag'
          org.phone_numbers.create! content: '555-884-2001'
        end

        PaperTrail.track_changes_with(raw_input3) do
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

  context 'searching by name' do
    let(:gallery) { Fabricate :organization }
    let(:zwirner) { Fabricate :organization }

    before do
      Organization.recreate_index!

      Fabricate(
        :organization_name,
        organization: gallery,
        content: 'Quux Gallery'
      )

      Fabricate(
        :organization_name,
        organization: zwirner,
        content: 'David Zwirner Gallery'
      )

      Organization.all.each(&:es_index)
      Organization.refresh_index!
    end

    it 'includes organization names and makes them searchable' do
      expect(Organization.estella_search(term: 'quux')).to eq([gallery])
    end

    it 'autocompletes organizations by name' do
      expect(Organization.estella_search(term: 'quu')).to eq([gallery])
    end

    it 'uses shingle analysis' do
      expect(Organization.estella_search(term: 'zwir')).to eq([zwirner])
    end

    it 'boosts organizations by location count' do
      galerie = Fabricate :organization

      Fabricate(
        :organization_name,
        organization: galerie,
        content: 'Quux Galerie'
      )

      2.times { Fabricate :location, organization: galerie }

      galerie.es_index
      Organization.refresh_index!

      expect(Organization.estella_search(term: 'quux')).to eq([galerie, gallery])
    end
  end

  context 'searching by other organization details' do
    let(:organization) { Fabricate :organization }

    before do
      Organization.recreate_index!

      Fabricate(
        :location,
        organization: organization,
        content: 'Berlin, Germany',
        city: 'Berlin',
        country: 'Germany'
      )

      Fabricate(
        :organization_tag,
        organization: organization,
        tag: Fabricate(:tag, name: 'fooy')
      )

      Fabricate(
        :website,
        organization: organization,
        content: 'http://www.example.com'
      )

      organization.es_index
      Organization.refresh_index!
      # using the default estella query
      allow(Organization).to receive(:estella_search_query).and_return(Estella::Query)
    end

    it 'includes organization locations and makes them searchable' do
      expect(Organization.estella_search(term: 'berlin')).to eq([organization])
      expect(Organization.estella_search(term: 'germany')).to eq([organization])
    end

    it 'includes tags and makes them searchable' do
      expect(Organization.estella_search(term: 'foo')).to eq([organization])
    end

    it 'includes website urls and makes them searchable' do
      expect(Organization.estella_search(term: 'www.example')).to eq([organization])
    end
  end
end
