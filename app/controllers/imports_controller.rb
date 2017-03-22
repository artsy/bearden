class ImportsController < ApplicationController
  expose(:import_results) do
    Import.order('created_at desc').map(&ImportResult.method(:new))
  end
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
