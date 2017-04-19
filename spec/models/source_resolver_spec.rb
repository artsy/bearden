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
        first_source = Fabricate(
          :source,
          email_rank: 1,
          location_rank: 1,
          organization_name_rank: 1,
          phone_number_rank: 1,
          website_rank: 1
        )

        second_source = Fabricate(
          :source,
          email_rank: 2,
          location_rank: 2,
          organization_name_rank: 2,
          phone_number_rank: 2,
          website_rank: 2
        )

        new_source = Source.new(
          name: 'new',
          email_rank: first_source.email_rank,
          location_rank: second_source.location_rank,
          organization_name_rank: 3,
          phone_number_rank: second_source.phone_number_rank,
          website_rank: first_source.website_rank
        )

        result = SourceResolver.resolve new_source

        expect(result).to eq true

        expect(new_source.reload.email_rank).to eq 1
        expect(first_source.reload.email_rank).to eq 2
        expect(second_source.reload.email_rank).to eq 3

        expect(first_source.location_rank).to eq 1
        expect(new_source.location_rank).to eq 2
        expect(second_source.location_rank).to eq 3

        expect(first_source.organization_name_rank).to eq 1
        expect(second_source.organization_name_rank).to eq 2
        expect(new_source.organization_name_rank).to eq 3

        expect(first_source.phone_number_rank).to eq 1
        expect(new_source.phone_number_rank).to eq 2
        expect(second_source.phone_number_rank).to eq 3

        expect(new_source.website_rank).to eq 1
        expect(first_source.website_rank).to eq 2
        expect(second_source.website_rank).to eq 3
      end
    end

    context 'demoting top source' do
      it 'pulls up other sources' do
        first_source = Fabricate :source, email_rank: 1
        second_source = Fabricate :source, email_rank: 2
        third_source = Fabricate :source, email_rank: 3

        first_source.email_rank = 2

        SourceResolver.resolve first_source

        expect(first_source.reload.email_rank).to eq 2
        expect(second_source.reload.email_rank).to eq 1
        expect(third_source.reload.email_rank).to eq 3
      end
    end

    context 'promoting source' do
      it 'drops sources down' do
        first_source = Fabricate :source, email_rank: 1
        second_source = Fabricate :source, email_rank: 2
        third_source = Fabricate :source, email_rank: 3

        second_source.email_rank = 1

        SourceResolver.resolve second_source

        expect(first_source.reload.email_rank).to eq 2
        expect(second_source.reload.email_rank).to eq 1
        expect(third_source.reload.email_rank).to eq 3
      end
    end
  end
end
