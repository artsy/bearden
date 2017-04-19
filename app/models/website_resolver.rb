class WebsiteResolver
  attr_reader :results

  def self.resolve(url)
    resolver = new(url)
    resolver.resolve
    resolver
  end

  def initialize(url)
    @url = url
    @results = []
  end

  def resolve
    resolve_url if @url
  end

  def resolved_url
    @results.last&.fetch :content
  end

  private

  def resolve_url
    add_protocol unless protocol?
    response = connection.get(@url)
    add_result(response.env)
  rescue Faraday::Error
    @results = []
  end

  def protocol?
    @url.start_with? 'http://', 'https://'
  end

  def add_protocol
    @url = "http://#{@url}"
  end

  def connection
    redirect_options = { callback: method(:callback) }

    @connection ||= Faraday.new do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects, redirect_options
      faraday.adapter Faraday.default_adapter
    end
  end

  def callback(old, _)
    add_result(old)
  end

  def add_result(faraday_env)
    result = { status: faraday_env[:status], content: faraday_env[:url].to_s }
    @results << result
  end
end
