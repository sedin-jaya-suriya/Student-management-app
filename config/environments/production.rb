# config/environments/production.rb

require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings in this file override config/application.rb.

  # Do not reload application code between requests.
  config.enable_reloading = false

  # Eager load application code for production.
  config.eager_load = true

  # Do not show detailed error pages to users.
  config.consider_all_requests_local = false

  # Enable controller caching.
  config.action_controller.perform_caching = true

  # Serve CSS, JavaScript, images, and other assets.
  # This is required because Render is returning 404 errors for /assets.
  config.public_file_server.enabled = ENV.fetch(
    "RAILS_SERVE_STATIC_FILES",
    "true"
  ) == "true"

  # Cache fingerprinted assets for one year.
  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.year.to_i}"
  }

  # Use local storage for Active Storage uploads on Render.
  # Note: On Render Free tier, this disk is ephemeral.
  config.active_storage.service = :local

  # Render terminates SSL before forwarding requests to Rails.
  config.assume_ssl = true

  # Force HTTPS.
  config.force_ssl = true

  # Log requests to STDOUT.
  config.log_tags = [ :request_id ]

  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Use the log level from the environment.
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Do not log Render health-check requests.
  config.silence_healthcheck_path = "/up"

  # Disable deprecation logging in production.
  config.active_support.report_deprecations = false

  # Use Solid Cache.
  config.cache_store = :solid_cache_store

  # Use the built-in async adapter since Redis is not used
  config.active_job.queue_adapter = :async



  # Use the Render URL for links generated in emails.
  config.action_mailer.default_url_options = {
    host: ENV.fetch(
      "APP_HOST",
      "student-management-app-2-t11x.onrender.com"
    ),
    protocol: "https"
  }

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address: ENV["SMTP_ADDRESS"],
    port: ENV["SMTP_PORT"],
    domain: ENV["APP_HOST"],
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    authentication: :plain,
    enable_starttls_auto: true
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  # Enable locale fallbacks.
  config.i18n.fallbacks = true

  # Do not create schema.rb after production migrations.
  config.active_record.dump_schema_after_migration = false

  # Show only IDs when inspecting Active Record objects.
  config.active_record.attributes_for_inspect = [ :id ]

  # Allow Render to access the application.
  config.hosts.clear
end
