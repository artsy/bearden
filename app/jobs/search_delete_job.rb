class SearchDeleteJob
  include Sidekiq::Worker

  def perform(klass, id)
    obj = klass.constantize.find(id)
    return unless obj
    obj.es_delete
  end
end
