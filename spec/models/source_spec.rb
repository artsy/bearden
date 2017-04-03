require 'rails_helper'

describe Source do
  describe '#rank_for' do
    context 'with known type' do
      it 'returns the rank for that type' do
        source = Fabricate :source, email_rank: 17
        email_rank = source.rank_for :email_rank
        expect(email_rank).to eq 17
      end
    end

    context 'with an unknown type' do
      it 'raises UnknownRankType' do
        source = Fabricate :source

        expect do
          source.rank_for :asdf_rank
        end.to raise_exception Source::UnknownRankType
      end
    end
  end
end
