require 'rails_helper'

describe FactualPageJob do
  describe '#perform' do
    let(:rows) { [] }
    let(:client) { double(:client, rows: rows) }

    before do
      allow(Factual).to receive(:new).and_return client
      allow(client).to receive(:table).and_return client
      allow(client).to receive(:filters).and_return client
      allow(client).to receive(:page).and_return client
    end

    context 'with no FactualPage records yet' do
      it 'gets the first page' do
        expect(client).to receive(:page).with(1, per: 50)
        FactualPageJob.perform_now
      end
    end

    context 'with a FactualPage record' do
      it 'gets the next page' do
        Fabricate :factual_page, page: 2
        expect(client).to receive(:page).with(3, per: 50)
        FactualPageJob.perform_now
      end
    end

    context 'with a few FactualPage records' do
      it 'gets the next page' do
        Fabricate :factual_page, page: 1
        Fabricate :factual_page, page: 3
        Fabricate :factual_page, page: 2
        expect(client).to receive(:page).with(4, per: 50)
        FactualPageJob.perform_now
      end
    end

    context 'with galleries' do
      let(:rows) { [{ 'key' => 'value' }] }

      it 'creates a FactualPage record and enqueues another job' do
        FactualPageJob.perform_now
        expect(FactualPage.count).to eq 1
        expect(FactualPage.first.payload).to eq rows
        expect(FactualPageJob).to have_been_enqueued
      end
    end

    context 'with no galleries' do
      it 'does not enqueue another job' do
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 0
        FactualPageJob.perform_now
        expect(FactualPage.count).to eq 0
        expect(FactualPageJob).to_not have_been_enqueued
      end
    end
  end
end
