module Auditable
  extend ActiveSupport::Concern

  included do
    has_paper_trail ignore: %i[created_at updated_at]
  end

  def sources
    actors.select { |actor| actor.respond_to?(:source) }.map(&:source)
  end

  def actors
    versions.map(&:actor)
  end
end
