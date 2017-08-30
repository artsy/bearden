module Searchable
  # Makes a model searchable via Elasticsearch.
  # @see https://github.com/artsy/estella
  extend ActiveSupport::Concern
  include Estella::Searchable

  included do
    index_name [name.downcase.pluralize, Rails.env].join('_')

    # disable estella inline indexing
    skip_callback(:save, :after, :es_index)
    skip_callback(:destroy, :after, :es_delete)

    # background indexing
    after_save :delay_es_index
    after_destroy :delay_es_delete
  end

  def delay_es_index
    SearchIndexJob.perform_async(self.class.name, id)
  end

  def delay_es_delete
    SearchDeleteJob.perform_async(self.class.name, id)
  end
end
