class ImportsController < ApplicationController
  expose(:import)
  expose(:import_result) { ImportResult.new(import) }

  def create
    if import.save
      ParseCsvImportJob.perform_later(import.id, params[:uri])
      redirect_to import_path(import)
    else
      render :new
    end
  end

  private

  def import_params
    default = { transformer: CsvTransformer }
    permitted = [:source_id, :description]
    params.require(:import).permit(permitted).merge(default)
  end
end
