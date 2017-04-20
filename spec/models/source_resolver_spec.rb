require 'rails_helper'

describe SourceResolver do
  describe '.resolve' do
    context 'with no other Sources' do
      it 'creates the new source' do
        new_source = Source.new(
          name: 'new',
          email_rank: 1,
          location_rank: 1,
          organization_name_rank: 1,
          phone_number_rank: 1,
          website_rank: 1
        )

        SourceResolver.resolve new_source

        expect(new_source).to be_persisted
      end
    end

    context 'with a mixture of lower and higher ranks' do
      it 'creates the new source and adjusts the ranks of the existing ones' do
        source_a = Fabricate(
          :source,
          email_rank: 1,
          location_rank: 1,
          organization_name_rank: 1,
          phone_number_rank: 1,
          website_rank: 1
        )

        source_b = Fabricate(
          :source,
          email_rank: 2,
          location_rank: 2,
          organization_name_rank: 2,
          phone_number_rank: 2,
          website_rank: 2
        )

        source_c = Source.new(
          name: 'new',
          email_rank: source_a.email_rank,
          location_rank: source_b.location_rank,
          organization_name_rank: 3,
          phone_number_rank: source_b.phone_number_rank,
          website_rank: source_a.website_rank
        )

        result = SourceResolver.resolve source_c

        expect(result).to eq true

        expect(source_c.reload.email_rank).to eq 1
        expect(source_a.reload.email_rank).to eq 2
        expect(source_b.reload.email_rank).to eq 3

        expect(source_a.location_rank).to eq 1
        expect(source_c.location_rank).to eq 2
        expect(source_b.location_rank).to eq 3

        expect(source_a.organization_name_rank).to eq 1
        expect(source_b.organization_name_rank).to eq 2
        expect(source_c.organization_name_rank).to eq 3

        expect(source_a.phone_number_rank).to eq 1
        expect(source_c.phone_number_rank).to eq 2
        expect(source_b.phone_number_rank).to eq 3

        expect(source_c.website_rank).to eq 1
        expect(source_a.website_rank).to eq 2
        expect(source_b.website_rank).to eq 3
      end
    end

    context 'demoting top source' do
      it 'pulls up other sources' do
        source_a = Fabricate :source, email_rank: 1
        source_b = Fabricate :source, email_rank: 2
        source_c = Fabricate :source, email_rank: 3

        source_a.email_rank = 2

        SourceResolver.resolve source_a

        expect(source_b.reload.email_rank).to eq 1
        expect(source_a.reload.email_rank).to eq 2
        expect(source_c.reload.email_rank).to eq 3
      end
    end

    context 'promoting source' do
      it 'drops sources down' do
        source_a = Fabricate :source, email_rank: 1
        source_b = Fabricate :source, email_rank: 2
        source_c = Fabricate :source, email_rank: 3

        source_b.email_rank = 1

        SourceResolver.resolve source_b

        expect(source_b.reload.email_rank).to eq 1
        expect(source_a.reload.email_rank).to eq 2
        expect(source_c.reload.email_rank).to eq 3
      end
    end
  end
end
