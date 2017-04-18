class StartSyncJob < ApplicationJob
  attr_accessor :sync, :part_size

  def perform(sync_id, part_size = OrganizationExportJob::PART_SIZE)
    @sync = Sync.find_by id: sync_id
    @part_size = part_size
    return unless sync

    if imports_to_sync?
      start_sync
    else
      sync.skip
    end
  end

  private

  def imports_to_sync?
    Import.where(state: ImportMicroMachine::FINISHED).any?
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
