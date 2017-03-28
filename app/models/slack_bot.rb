class SlackBot
  def self.post(message)
    new(message).post
  end

  def initialize(message)
    @message = message
  end

  def post
    options = default_options.merge(text: @message)
    client.chat_postMessage options
  end

  private

  def client
    @client ||= Slack::Web::Client.new
  end

  def channel
    '#bearden-burden'
  end

  def default_options
    {
      as_user: true,
      channel: channel,
      link_names: true
    }
  end
end
