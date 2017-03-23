class ImportChannel < ApplicationCable::Channel
  def subscribed
    stream_from "import_#{@params[:import_id]}"
  end
end
