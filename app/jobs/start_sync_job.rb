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

    if force || some_imports_should_sync?
      start_sync
    else
      sync.skip
    end
  end

  private

  def some_imports_should_sync?
    finished_imports = Import.where(state: ImportMicroMachine::FINISHED)
    finished_imports.any?(&:should_sync?)
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

    sync.update total_parts: total_parts

    (1..total_parts).each do |part_number|
      OrganizationExportJob.perform_later(sync.id, part_number)
    end
  end
end
