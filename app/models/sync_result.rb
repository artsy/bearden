class SyncResult
  attr_reader :sync

  delegate(
    :created_at,
    :id,
    :state,
    :total_parts,
    :updated_at,
    :uploaded_parts,
    to: :sync
  )

  include ActionView::Helpers::DateHelper

  def initialize(sync)
    @sync = sync
  end

  def duration
    distance_of_time_in_words updated_at, created_at
  end

  def parts
    return 'n/a' if state == SyncMicroMachine::SKIPPED
    "#{uploaded_parts}/#{total_parts}"
  end
end
