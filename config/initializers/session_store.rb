# Configure cookie-based session store for browser sessions
Rails.application.config.session_store :cookie_store,
  key: "_student_management_session",
  same_site: :lax,
  secure: Rails.env.production?

# Ensure middleware stack includes session and flash when not api-only
if Rails.application.config.respond_to?(:api_only) && Rails.application.config.api_only
  Rails.application.config.middleware.use ActionDispatch::Cookies
  Rails.application.config.middleware.use ActionDispatch::Session::CookieStore, Rails.application.config.session_options
end
