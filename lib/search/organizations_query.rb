module Search
  class OrganizationsQuery < Estella::Query
    def initialize(params)
      super
      add_term_query
      add_field_boost
    end

    def query_definition
      {
        bool: {
          must: {
            multi_match: {
              type: 'best_fields',
              fields: [
                'name.ngram^5',
                'name.default^5',
                'name.shingle^1',
                'name.snowball^1'
              ],
              query: params[:term]
            }
          },
          should: {
            match_phrase: {
              name: params[:term]
            }
          }
        }
      }
    end
  end
end
