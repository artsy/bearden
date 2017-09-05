module Authentication
  module Helpers
    extend ActiveSupport::Concern

    TRUSTED_APPS = %w[volt bearden].freeze

    included do
      use Middleware::JwtMiddleware
      rescue_from JWT::DecodeError do |_e|
        error!('Unauthorized', 401)
      end

      before do
        authenticate_app!
      end

      helpers do
        # Require that signature is valid by decoding payload w/ secret.
        # It must have an 'aud' attribute containing the name of a trusted app.
        # The API grants full access to these requests.
        def authenticate_app!
          return if TRUSTED_APPS.include?(client_app)
          error!('Unauthorized', 401)
        end

        def jwt_payload
          @jwt_payload ||= env['JWT_PAYLOAD']
        end

        def client_app
          @client_app ||= jwt_payload&.fetch('aud', nil)
        end
      end
    end
  end
end
