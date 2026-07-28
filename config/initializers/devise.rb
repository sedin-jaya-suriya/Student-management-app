return unless defined?(Devise)

# Load ORM adapter so Devise adds model helpers (e.g. `devise` class method)
require "devise/orm/active_record"

Devise.setup do |config|
  config.mailer_sender = ENV.fetch("DEVISE_MAILER_SENDER", "please-change-me@example.com")
  config.navigational_formats = [ "*/*", :html, :turbo_stream ]
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  jwt_secret = ENV.fetch("DEVISE_JWT_SECRET_KEY", Rails.application.secret_key_base)

  config.jwt do |jwt|
    jwt.secret = jwt_secret

    # JWT is ONLY dispatched when logging in via the API endpoint
    jwt.dispatch_requests = [
      [ "POST", %r{^/api/login$} ]
    ]

    # JWT is ONLY revoked when logging out via the API endpoint
    jwt.revocation_requests = [
      [ "DELETE", %r{^/api/logout$} ]
    ]

    jwt.expiration_time = 1.day.to_i
  end

  # Skip session storage for API requests (JWT) but NOT for web requests
  config.skip_session_storage = [ :http_auth, :jwt ]
end
