require 'rails_helper'

describe RawInputTransformJob do
  describe '#perform' do
    context 'with a valid raw_input id' do
      it 'applies the raw_input changes' do
        raw_input = Fabricate :raw_input
        expect(RawInputChanges).to receive(:apply).with(raw_input)
        RawInputTransformJob.new.perform raw_input.id
      end
    end

    context 'with an invalid raw_input id' do
      it 'returns early' do
        expect(RawInputChanges).to_not receive(:apply)
        RawInputTransformJob.new.perform nil
      end
    end
  end
end
