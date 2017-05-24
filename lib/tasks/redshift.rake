namespace :redshift do
  desc 'Sync Redshift table'
  task sync: :environment do
    SyncManagementJob.perform_later
  end

  desc 'Force sync data. Useful when revising schema'
  task force_sync: :environment do
    StartSyncJob.force_sync
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
          in_business character varying, \
          latitude double precision, \
          longitude double precision, \
          location varchar(1024), \
          organization_name character varying, \
          organization_type character varying, \
          phone_number character varying, \
          tag_names character varying, \
          website character varying, \
          sources character varying \
        )"
      )

      conn.exec(
        "GRANT USAGE ON SCHEMA #{Redshift::SCHEMA} TO GROUP read_only;"
      )
      conn.exec(
        "GRANT SELECT ON TABLE #{Redshift::SCHEMA_TABLE} TO GROUP read_only;"
      )
    end
  end
end
