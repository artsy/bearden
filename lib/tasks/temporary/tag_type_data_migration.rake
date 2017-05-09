desc 'Convert certain tags to types'
task tag_type_data_migration: :environment do
  mapping = {
    "antique shop" => "antique shop",
    "artist estates / foundations" => "artist estates / foundations",
    "artist studios" => "artist studios",
    "artist" => "artist",
    "auction house" => "auction houses",
    "biennials / triennials" => "biennials / triennials",
    "charity / ngo" => nil,
    "corporate collection" => nil,
    "dealer" => "dealer",
    "fair" => "fairs",
    "gallery" => "gallery",
    "government organization" => nil,
    "museum" => "museum",
    "non-art organization" => "other",
    "performance venue" => nil,
    "print publishers and print dealers" => "print publishers and print dealers",
    "private collections" => "private collections",
    "publications / publishers / archives" => "publications / publishers / archives",
    "university museums / educational institutions" => "university museums / educational institutions",
  }

  for type_name, tag_name in mapping
    puts ''
    puts type_name
    Type.transaction do
      type = Type.create name: type_name
      tag = Tag.find_by name: tag_name

      if tag
        for org_tag in tag.organization_tags
          actor = org_tag.versions.first.actor
          PaperTrail.track_changes_with(actor) do
            org_tag.organization.organization_types.create type: type
          end
          print ?.
        end

        tag.organization_tags.delete_all
        tag.delete
      end
    end
  end
end
