Source.create name: 'Factual', rank: 1
Source.create name: 'HumanOutsourcer', rank: 2
Source.create name: 'Geocoder', rank: 3
Source.create name: 'Burden', rank: 4

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
