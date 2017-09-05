module Authentication
  module Helpers
    extend ActiveSupport::Concern

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
        # It must have an 'aud' attribute containing the Bearden app id.
        # The API grants full access to these requests.
        def authenticate_app!
          return if current_app == Rails.application.secrets.artsy_application_id
          error!('Unauthorized', 401)
        end

        def jwt_payload
          @jwt_payload ||= env['JWT_PAYLOAD']
        end

        def current_app
          @current_app ||= jwt_payload&.fetch('aud', nil)
        end
      end
    end
  end
end
