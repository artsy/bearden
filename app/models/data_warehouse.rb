class DataWarehouse
  class Result
    attr_accessor :before_count, :after_count, :errors

    def success?
      @errors.nil?
    end
  end

  def self.reset(sources)
    Result.new.tap do |result|
      Redshift.connect do |connection|
        begin
          # binding.pry
          warehouse = new(sources, result, connection)
          warehouse.reset
        rescue PG::Error => e
          result.errors = "#{e.class}: #{e.message}"
        end
      end
    end
  end

  def initialize(sources, result, connection)
    @sources = sources
    @region = Rails.application.secrets.aws_region
    @result = result
    @connection = connection
  end

  def reset
    @result.before_count = count_orgs
    truncate_table
    copy_source_data
    @result.after_count = count_orgs
  end

  private

  def count_orgs
    result = @connection.exec("SELECT COUNT(*) FROM #{Redshift::SCHEMA_TABLE}")
    result.values.flatten.first.to_i
  end

  def truncate_table
    @connection.exec("TRUNCATE #{Redshift::SCHEMA_TABLE}")
  end

  def copy_source_data
    @sources.each do |source|
      @connection.exec(
        "COPY #{Redshift::SCHEMA_TABLE} \
        (#{columns}) \
        FROM '#{source}' \
        WITH CREDENTIALS '#{s3_auth}' \
        DELIMITER ',' REGION '#{@region}' \
        CSV IGNOREHEADER 1 EMPTYASNULL"
      )
    end
  end

  def s3_auth
    id = Rails.application.secrets.aws_access_key_id
    key = Rails.application.secrets.aws_secret_access_key
    "aws_access_key_id=#{id};aws_secret_access_key=#{key}"
  end

  def columns
    CsvConverter.headers.join(',')
  end
end
