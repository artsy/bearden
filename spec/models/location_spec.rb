require 'rails_helper'

describe Organization, type: :model do
  context '.geocoder_source' do
    it 'creates a geocoder Source when one is not present' do
      Location.geocoder_source
      expect(Source.count).to eql 1
      expect(Source.first.name).to eql 'Geocoder'
    end

    it 'does not create a new Source when one is present' do
      Fabricate :source, name: 'Geocoder'
      expect(Source).to_not receive(:create)
      Location.geocoder_source
    end
  end
end
