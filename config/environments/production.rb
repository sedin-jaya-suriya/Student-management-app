require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here take precedence over
  # config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load application code.
  config.eager_load = true

  # Disable detailed error pages.
  config.consider_all_requests_local = false

  # Enable controller caching.
  config.action_controller.perform_caching = true

  # IMPORTANT:
  # Serve precompiled CSS, JavaScript and other assets.
  config.public_file_server.enabled = ENV.fetch(
    "RAILS_SERVE_STATIC_FILES",
    "true"
  ).present?

  # Cache fingerprinted assets.
  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.year.to_i}"
  }

  # Store Active Storage files locally.
  config.active_storage.service = :local

  # Render handles SSL before forwarding requests to Rails.
  config.assume_ssl = true

  # Force HTTPS.
  config.force_ssl = true

  # Log requests using the request ID.
  config.log_tags = [ :request_id ]

  # Send logs to STDOUT.
  config.logger =
    ActiveSupport::TaggedLogging.logger(STDOUT)

  # Set production log level.
  config.log_level =
    ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Do not log health-check requests.
  config.silence_healthcheck_path = "/up"

  # Disable deprecation reports.
  config.active_support.report_deprecations = false

  # Use Solid Cache.
  config.cache_store = :solid_cache_store

  # Use Solid Queue.
  config.active_job.queue_adapter =
    :solid_queue

  config.solid_queue.connects_to = {
    database: {
      writing: :queue
    }
  }

  # Configure URL generation for mailers.
  config.action_mailer.default_url_options = {
    host: ENV.fetch(
      "RENDER_EXTERNAL_HOSTNAME",
      "example.com"
    )
  }

  # Enable locale fallbacks.
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record
        .dump_schema_after_migration = false

  # Show only ID in production inspections.
  config.active_record
        .attributes_for_inspect = [ :id ]
end
