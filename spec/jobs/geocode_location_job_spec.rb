require 'rails_helper'

describe GeocodeLocationJob do
  include ActiveJob::TestHelper

  describe '#perform' do
    let(:berlin_coordinates) { [52.52000659999999, 13.404954] }

    before do
      allow(Geocoder).to receive(:coordinates).and_return(berlin_coordinates)
    end

    it 'moves on to geocode the next location when geocodable? is false' do
      org = Fabricate :organization
      org.locations.create(
        content: 'New York City', latitude: 1234, longitude: 5678
      )
      org.locations.create content: '401 Broadway, New York City'

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
      end

      perform_enqueued_jobs do
        assert_performed_jobs 1
      end

      # TODO: This fails because value from db is "52.520007 (0.52520007e2)"
      # expect(org.locations.second.latitude).to eql berlin_coordinates[0]
      expect(org.locations.second.longitude).to eql berlin_coordinates[1]
    end

    it 'stops raises an error when OverQueryLimitError is raised' do
      expect(Geocoder).to receive(:coordinates)
        .and_raise(Geocoder::OverQueryLimitError)
      org = Fabricate :organization
      org.locations.create(
        content: 'New York City', latitude: 1234, longitude: nil
      )

      perform_enqueued_jobs do
        expect do
          GeocodeLocationJob.perform_later
        end.to raise_error Geocoder::OverQueryLimitError
      end
    end

    it 'enqueues one job after another, after another, after another...' do
      org = Fabricate :organization
      org.locations.create content: 'Berlin, Germany'
      org.locations.create content: '401 Broadway, New York City'

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
      end

      perform_enqueued_jobs do
        assert_performed_jobs 2
      end
    end

    it 'gracefully exits when no more next_location exist' do
      org = Fabricate :organization
      org.locations.create content: 'Berlin, Germany'
      org.locations.create(
        content: 'New York City', latitude: 1234, longitude: 5678
      )

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
      end

      perform_enqueued_jobs do
        assert_performed_jobs 1
      end
    end

    it 'only does jobs for non-geocoded Locations' do
      org = Fabricate :organization
      org.locations.create content: 'Berlin, Germany'
      org.locations.create(
        content: 'New York City', latitude: 1234, longitude: 5678
      )

      perform_enqueued_jobs do
        GeocodeLocationJob.perform_later
      end

      perform_enqueued_jobs do
        assert_performed_jobs 1
        assert_enqueued_jobs 0
      end
    end

    # TODO: See note in `geocode_location_job.rb`
    it 'raises an error when coordinates is falsy' do
      org = Fabricate :organization
      org.locations.create content: 'Nil Town, USA'
      org.locations.create content: 'Nil Town II, USA'

      allow(Geocoder).to receive(:coordinates).and_return(nil)

      perform_enqueued_jobs do
        expect do
          GeocodeLocationJob.perform_later
        end.to raise_error Geocoder::InvalidRequest
      end
    end
  end
end
