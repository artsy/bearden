class FactualPageJob < ApplicationJob
  def perform
    factual_galaries = client.table(table).filters(filters).page(page, per: 50).rows
    return unless factual_galaries.any?
    FactualPage.create payload: factual_galaries, table: table, page: page
    FactualPageJob.perform_later
  end

  private

  def client
    @factual ||= Factual.new(ENV['FACTUAL_KEY'], ENV['FACTUAL_SECRET'])
  end

  def table
    'places-us'
  end

  def filters
    { 'category_ids' => { '$includes' => 310 } }
  end

  def page
    return 1 unless FactualPage.any?
    FactualPage.maximum(:page) + 1
  end
end
