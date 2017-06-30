require 'rails_helper'

describe GeocodeLocationJob do
  include ActiveJob::TestHelper

  describe '#perform' do
    before do
      # Stub Geocoder.search so that tests don't use precious API
      allow(Geocoder).to receive(:search)
    end

    it 'raises an error when OverQueryLimitError is raised' do
      expect(Geocoder).to receive(:search)
        .and_raise(Geocoder::OverQueryLimitError)
      org = Fabricate :organization
      org.locations.create(
        content: 'New York City',
        geocode_response: nil
      )

      perform_enqueued_jobs do
        expect do
          GeocodeLocationJob.perform_later
        end.to raise_error Geocoder::OverQueryLimitError
      end
    end

    it 'enqueues one job after another, after another, after another...' do
      org = Fabricate :organization
      org.locations.create(
        content: 'Berlin, Germany',
        geocode_response: nil
      )
      org.locations.create(
        content: '401 Broadway, New York City',
        geocode_response: nil
      )

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
        assert_performed_jobs 3
      end
    end

    it 'gracefully exits when no more next_location exist' do
      org = Fabricate :organization
      org.locations.create content: 'Berlin, Germany'
      org.locations.create(
        content: 'New York City', geocode_response: { foo: 'bar' }.to_json
      )

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
        assert_performed_jobs 2
      end
    end

    it 'only does jobs for non-geocoded Locations' do
      org = Fabricate :organization
      org.locations.create content: 'Berlin, Germany', geocode_response: nil
      org.locations.create(
        content: 'New York City', geocode_response: { foo: 'bar' }.to_json
      )

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
        assert_performed_jobs 2
        assert_enqueued_jobs 0
      end
    end

    it 'saves location with fallback value when Geocoder results are nil' do
      fallback_coordinates = GeocodeLocationJob::FALLBACK_COORDINATES

      allow(Geocoder).to receive(:search)
        .and_return([])

      org = Fabricate :organization
      org.locations.create content: 'Nil Town, USA', geocode_response: nil

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
      end

      expect(org.locations.first.latitude).to eq fallback_coordinates[0]
      expect(org.locations.first.longitude).to eq fallback_coordinates[1]
      expect(org.locations.first.country).to eq nil
      expect(org.locations.first.city).to eq nil

      error = 'GeocodeLocationJob::NoResultsFound'
      expect(org.locations.first.geocode_response).to eq error
    end

    it 'records an Import and Source for all records' do
      organization = Fabricate :organization
      Fabricate :location, geocode_response: nil, organization: organization
      Fabricate :location, geocode_response: nil, organization: organization

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later

        assert_performed_jobs 3
        expect(Location.count).to eq 2

        Location.all.each do |location|
          actor = location.versions.last.actor
          expect(actor).to eq 'Geocoder'
        end
      end
    end
  end
end
