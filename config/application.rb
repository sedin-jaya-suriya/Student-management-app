require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module StudentManagement
  class Application < Rails::Application
    config.load_defaults 8.1

    # This app serves both HTML pages and JSON APIs. Ensure full middleware
    # stack (sessions, flash, cookies) is available by disabling api_only.
    config.api_only = false
  end
end
