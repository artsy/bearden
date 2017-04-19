ranks = %i[
  email_rank location_rank organization_name_rank phone_number_rank website_rank
]

[
  { name: 'Factual', rank: 1 },
  { name: 'HumanOutsourcer', rank: 2 },
  { name: 'Burden', rank: 3 }
].each do |source|
  source_attrs = ranks.each_with_object({}) do |key, memo|
    memo[key] = source[:rank]
  end
  next if Source.exists?(name: source[:name])
  Source.create source_attrs.merge(name: source[:name])
end

[
  'ancient art / artifacts / antiquities',
  'antique shop',
  'art merchandise and multiples / ephemera',
  'art',
  'artist estates / foundations',
  'artist studios',
  'artist',
  'auction houses',
  'benefit auctions',
  'biennials / triennials',
  'commercial auctions',
  'contemporary',
  'dealer',
  'design / decorative arts',
  'european old masters',
  'fairs',
  'gallery',
  'indigenous art',
  'jewelry',
  'museum',
  'nonprofit organizations',
  'other',
  'photography',
  'print publishers and print dealers',
  'private collections',
  'publications / publishers / archives',
  'university museums / educational institutions'
].each do |name|
  next if Tag.exists?(name: name)
  Tag.create name: name
end
