namespace :report do
  desc 'Prints a count and list of websites with possible duplicate organizations'
  task duplicate_organizations: :environment do
    domains = Website.pluck(:content, :organization_id).group_by do |item|
      content, _id = item
      content.split('/')[2]
    end

    duplicates = domains.select do |_website, grouped_results|
      next false unless grouped_results.size > 1
      grouped_results.map(&:last).uniq.size > 1
    end

    puts "Count: #{duplicates.values.map(&:last).flatten.uniq.count}"
    puts duplicates
  end
end
