class StartSyncJob < ApplicationJob
  attr_accessor :sync
  attr_reader :part_size

  def self.force_sync
    sync = Sync.create state: SyncMicroMachine::STARTING
    perform_later sync.id, force: true
  end

  def perform(sync_id, force: false)
    @sync = Sync.find_by id: sync_id
    @part_size = Rails.application.secrets.batch_export_size

    return unless sync

    if force || should_sync?
      start_sync
    else
      sync.skip
    end
  end

  private

  def should_sync?
    finished_imports = Import.where(state: ImportMicroMachine::FINISHED)

    return false unless finished_imports

    imports_to_sync = finished_imports.count

    finished_imports.each do |import|
      errors_count = import.raw_inputs.where('exception is not null').count
      next unless import.raw_inputs.count == errors_count
      imports_to_sync -= 1
    end

    return imports_to_sync > 0
  end

  def start_sync
    SlackBot.post(':seedling: Sync starting')
    update_finished_imports
    enqueue_export_jobs
    sync.export
  end

  def update_finished_imports
    Import.where(state: ImportMicroMachine::FINISHED).each(&:sync)
  end

  def enqueue_export_jobs
    total_parts = Organization.count / @part_size + 1

    sync.update_attributes total_parts: total_parts

    (1..total_parts).each do |part_number|
      OrganizationExportJob.perform_later(sync.id, part_number)
    end
  end
end
