module Middleware
  class JwtMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['HTTP_AUTHORIZATION']
        token = parse_header env['HTTP_AUTHORIZATION']
        env['JWT_PAYLOAD'], _headers = JWT.decode(token, Rails.application.secrets.jwt_secret)
      end
      @app.call env
    end

    def parse_header(header)
      header.split(' ').last
    end
  end
end
