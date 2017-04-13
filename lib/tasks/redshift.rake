namespace :redshift do
  desc 'Sync Redshift table'
  task sync: :environment do
    SyncManagementJob.perform_later
  end

  desc 'Drop the Redshift table'
  task drop: :environment do
    Redshift.connect do |conn|
      conn.exec("DROP SCHEMA IF EXISTS #{Redshift::SCHEMA} CASCADE")
    end
  end

  desc 'Create the Redshift table'
  task create: :environment do
    Redshift.connect do |conn|
      conn.exec("CREATE SCHEMA IF NOT EXISTS #{Redshift::SCHEMA}")
      conn.exec(
        "CREATE TABLE IF NOT EXISTS #{Redshift::SCHEMA_TABLE} ( \
          bearden_id integer, \
          city character varying, \
          country character varying, \
          email character varying, \
          latitude double precision, \
          longitude double precision, \
          location character varying, \
          organization_name character varying, \
          phone_number character varying, \
          tag_names character varying, \
          website character varying \
        )"
      )
    end
  end
end
