require 'rails_helper'

describe WebsiteResolver do
  context 'when url is nil' do
    it 'returns en empty array' do
      results = WebsiteResolver.resolve(nil).results
      expect(results).to eq []
    end
  end

  context 'when there is no protocol' do
    it 'returns that url with the protocol added' do
      stub_request(:get, 'http://www.example.com')
      results = WebsiteResolver.resolve('www.example.com/').results
      expect(results).to eq [
        { status: 200, content: 'http://www.example.com/' }
      ]
    end
  end

  context 'with the https protocol' do
    it 'does not alter protocol' do
      secure_url = 'https://www.artsy.net/'
      stub_request(:get, secure_url)
      results = WebsiteResolver.resolve(secure_url).results
      expect(results).to eq [
        { status: 200, content: secure_url }
      ]
    end
  end

  context 'when the url redirects' do
    it 'returns both urls' do
      redirect_url = 'http://artsy.net'
      resolved_url = 'https://www.artsy.net/'
      headers = { 'Location' => resolved_url }
      stub_request(:get, redirect_url)
        .to_return(status: 301, headers: headers)
      stub_request(:get, resolved_url)
      resolver = WebsiteResolver.resolve(redirect_url)
      results = resolver.results
      expect(results).to eq [
        { status: 301, content: redirect_url },
        { status: 200, content: resolved_url }
      ]

      expect(resolver.resolved_url).to eq resolved_url
    end
  end

  context 'when the url is a 404' do
    it 'returns that url and status' do
      unknown_url = 'https://www.artsy.net/unknown.html'
      stub_request(:get, unknown_url).to_return(status: 404)
      results = WebsiteResolver.resolve(unknown_url).results
      expect(results).to eq [{ status: 404, content: unknown_url }]
    end
  end

  context 'when the url cannot be resolved' do
    it 'returns an empty array' do
      message = 'Failed to open TCP connection'
      exception = Faraday::ConnectionFailed.new(message)
      connection = double(:connection)
      allow(connection).to receive(:get).and_raise exception
      allow(Faraday).to receive(:new).and_return(connection)
      results = WebsiteResolver.resolve('something').results
      expect(results).to eq []
    end
  end
end
