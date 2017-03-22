Source.create name: 'Factual', rank: 1
Source.create name: 'HumanOutsourcer', rank: 2
Source.create name: 'Geocoder', rank: 3
Source.create name: 'Burden', rank: 4

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
  Tag.create name: name
end
