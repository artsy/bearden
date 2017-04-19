module Auditable
  extend ActiveSupport::Concern

  included do
    has_paper_trail ignore: %i[created_at updated_at]
  end

  def sources
    versions.map { |version| version.actor.import.source }
  end
end
