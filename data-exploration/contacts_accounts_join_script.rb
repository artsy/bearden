# TODO: From firmographic score, Clearbit data was excluded. Check with Ani about this decision.

# TODO: Hello, not everyone's computers are named 'lancew'
input_file = '/Users/lancew/Code/bearden/data-exploration/sources/contacts_accounts.csv'

output_file = '/Users/lancew/Code/bearden/data-exploration/exports/contacts_accounts_burden_ids.csv'

ids = []

white_list_source_headers = [
  'Contact ID',
  'Partner Type',
  'Subscription State',
  'Subscription Type',
  'Burden Organization ID',
  'Account Name',
  'Email',
  'Count of Opportunities',
  'Count of Won Opportunities',
  'Gallery Tier',
  'Burden Organization Name',
  'Burden Gallery Verification Score',
  'Burden Artist Score',
  'Burden Firmographic Score',
  'Burden Fair Score',
  'Burden Organization Score'
]

expanded_score_headers = [
  'locations_count',
  'fair_participations_count',
  'fair_participation_tiers_mean',
  'inquiry_requests_count',
  'purchases_count',
  'purchases_total',
  'artwork_bidders_count',
  'auction_lots_price_realized_average'
]

class ExpandedScoreFields
  def self.score(organization)
    new(organization).score
  end

  def initialize(organization)
    @organization = organization
  end

  def score
    [
      locations_count,
      fair_participations_count,
      fair_participation_tiers_mean,
      inquiry_requests_count,
      purchases_count,
      purchases_total,
      artwork_bidders_count,
      auction_lots_price_realized_average
    ]
  end

  private

  def locations_count
    @organization.locations_count
  end

  def fair_participations_count
    @organization.fair_participations_count
  end

  def fair_participation_tiers_mean
    sum = @organization.fair_participations.map { |p| p.fair.tier }.compact.sum || 0
    count = @organization.fair_participations_count || 0
    return nil if sum < 1 || count < 1
    count.fdiv(sum)
  end

  def inquiry_requests_count
    # We did not acocunt for relationship (represented or exhibited) because ~91% of records are nil.
    #
    # > o_artist_count = OrganizationArtist.count
    # => 275237
    # > empty_relationships_count = OrganizationArtist.where('relationship is ?', nil).count
    # => 250985
    # > empty_relationships_count.fdiv o_artist_count
    # => 0.9118868466085591
    #
    artists.map(&:inquiry_requests_count).compact.sum
  end

  def purchases_count
    artists.map(&:purchases_count).compact.sum
  end

  def purchases_total
    artists.map(&:purchases_total).compact.sum
  end

  def artwork_bidders_count
    artists.map(&:artwork_bidders_count).compact.sum
  end

  def auction_lots_price_realized_average
    sum = artists.map(&:auction_lots_price_realized_average).compact.sum || 0
    count = artists.count || 0
    return nil if sum < 1 || count < 1
    sum.fdiv artists.count
  end

  def artists
    @artists ||= @organization.organization_artists.map(&:artist)
  end
end

CSV.open(output_file, 'wb', headers: white_list_source_headers + expanded_score_headers, write_headers: true) do |output_csv|
  CSV.foreach(input_file, headers: true, encoding: "iso-8859-1:UTF-8") do |row|
    burden_id = row['Burden Organization ID']
    next if burden_id == '' || ids.include?(burden_id)
    organization = Organization.find_by id: burden_id
    next unless organization
    expanded_score_fields = ExpandedScoreFields.score organization
    source_fields = row.values_at(*white_list_source_headers)
    output_csv << source_fields + expanded_score_fields
    ids << burden_id
  end
end
