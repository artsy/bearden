class SearchIndexJob
  include Sidekiq::Worker

  def perform(klass, id)
    obj = klass.constantize.find(id)
    return unless obj
    obj.es_index
  end
end
