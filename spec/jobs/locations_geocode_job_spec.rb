require 'rails_helper'

RSpec.describe LocationsGeocodeJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    before do
      allow(Geocoder).to receive(:coordinates).and_return([52.52000659999999, 13.404954])
    end

    it 'does not use actual Geocoder API calls for these tests' do
      coordinates = Geocoder.coordinates 'Foo Street, Quxville, Barlandia'
      expect(coordinates).to eq [52.52000659999999, 13.404954]
    end

    it 'enqueues one job after another' do
      location1 = Fabricate :location, content: 'Berlin, Germany'
      Fabricate :location, content: '401 Broadway New York City'

      perform_enqueued_jobs do
        LocationsGeocodeJob.perform_later location1.id
      end

      perform_enqueued_jobs do
        assert_performed_jobs 2
      end
    end

    it 'only enqueues jobs for Locations that are not geoencoded' do
      location1 = Fabricate :location, content: 'Berlin, Germany'
      Fabricate :location, content: 'New York City', latitude: 1234, longitude: 5678

      perform_enqueued_jobs do
        LocationsGeocodeJob.perform_later location1.id
      end

      assert_performed_jobs 1
      assert_enqueued_jobs 0
    end
  end
end
