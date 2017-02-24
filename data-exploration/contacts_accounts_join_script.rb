# ## 1. Expand the Burden Scores into the fields that comprise the scores
#
# - Burden Artist Score
# - Burden Firmographic Score
# - Burden Fair Score
# - Burden Organization Score
#
# ### a) Burden Artist Score consists of
#
#   - artist.inquiry_requests_count
#   - artist.purchases_count
#   - artist.purchases_total
#   - artist.artwork_bidders_count
#   - artist.auction_lots_price_realized_average
#
# ### b) Firmographic Score
#
#   - organization.locations_count
#
# ### c) Fair Score
#
#   - sum of all fair participatidions tiers

# contacts_accounts.csv

# Get a row from csv
# Find the burden ID
# Get expanded score fields
# Write a row to a new CSV

# We execute here: /Users/lancew/Code/burden-api
# Script lives here: /Users/lancew/Code/bearden/data-exporation

input_file = '/Users/lancew/Code/bearden/data-exploration/sources/contacts_accounts.csv'

output_file = '/Users/lancew/Code/bearden/data-exploration/exports/contacts_accounts_burden_ids.csv'

ids = []

white_list = [
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

CSV.open(output_file, 'wb', headers: white_list, write_headers: true) do |output_csv|
  CSV.foreach(input_file, headers: true, encoding: "iso-8859-1:UTF-8") do |row|
    burden_id = row['Burden Organization ID']
    next if burden_id == '' || ids.include?(burden_id)
    output_csv << row.values_at(*white_list)
    ids << burden_id
  end
end
