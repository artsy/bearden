class SourcesController < ApplicationController
  expose(:sources) { Source.order(:name) }
  expose(:source)

  def create
    SourceResolver.resolve(source)

    if source.persisted?
      redirect_to sources_path
    else
      render :new
    end
  end

  private

  def source_params
    params.require(:source).permit(
      :name,
      :email_rank,
      :location_rank,
      :organization_name_rank,
      :phone_number_rank,
      :website_rank
    )
  end
end
