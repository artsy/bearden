class FinalizeImportJob < ApplicationJob
  attr_reader :import

  queue_as :default

  def perform(import_id)
    @import = Import.find_by id: import_id
    return unless import

    broadcast_result

    export_errors
    post_to_slack

    import.finish
    broadcast_result
  end

  private

  def import_result
    @import_result ||= ImportResult.new(@import)
  end

  def broadcast_result
    channel = "import_#{@import.id}"
    ActionCable.server.broadcast channel, import_result
  end

  def export_errors
    ImportErrors.export(@import)
  end

  def post_to_slack
    url = Rails.application.routes.url_helpers.import_url(@import)
    message = ":tada: #{import_result.name} finished: #{url}"
    SlackBot.post(message)
  end
end
