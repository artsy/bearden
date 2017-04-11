class SyncsController < ApplicationController
  expose(:recent_sync_results) do
    Sync.order(created_at: :desc).limit(20).map(&SyncResult.method(:new))
  end
end
