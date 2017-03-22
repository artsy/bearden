ranks = %i(
  email_rank location_rank organization_name_rank phone_number_rank website_rank
)

[
  { name: 'Factual', rank: 1 },
  { name: 'HumanOutsourcer', rank: 2 },
  { name: 'Geocoder', rank: 3 },
  { name: 'Burden', rank: 4 }
].each do |source|
  source_attrs = ranks.each_with_object({}) do |key, memo|
    memo[key] = source[:rank]
  end
  Source.create source_attrs.merge(name: source[:name])
end

[
  'ancient art / artifacts / antiquities',
  'antique shop',
  'art',
  'art merchandise and multiples / ephemera',
  'artist',
  'artist estates / foundations',
  'artist studios',
  'auction houses',
  'benefit auctions',
  'biennials / triennials',
  'commercial auctions',
  'dealer',
  'design / decorative arts',
  'fairs',
  'gallery',
  'jewelry',
  'museum',
  'nonprofit organizations',
  'other',
  'print publishers and print dealers',
  'private collections',
  'publications / publishers / archives',
  'university museums / educational institutions'
].each do |name|
  Tag.create name: name
end
