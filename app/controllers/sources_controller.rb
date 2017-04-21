class SourcesController < ApplicationController
  expose(:sources) { Source.order(:name) }
  expose(:source)

  expose(:ordered_sources) do
    {
      email_rank: Source.order(:email_rank),
      location_rank: Source.order(:location_rank),
      organization_name_rank: Source.order(:organization_name_rank),
      phone_number_rank: Source.order(:phone_number_rank),
      website_rank: Source.order(:website_rank)
    }
  end

  def create
    return redirect_alert unless @is_admin

    if SourceResolver.resolve(source)
      redirect_to sources_path
    else
      render :new
    end
  end

  def update
    return redirect_alert unless @is_admin

    source.update(source_params)

    if SourceResolver.resolve(source)
      redirect_to sources_path
    else
      redirect_to edit_source_path(source)
    end
  end

  private

  def redirect_alert
    redirect_to(sources_url, alert: 'Wrong permissions')
  end

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
