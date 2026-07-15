# This file is copied to spec/ when you run 'rails generate rspec:install'

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

# Requires supporting ruby files with custom matchers and macros, etc.
Rails.root.glob("spec/support/**/*.rb").sort_by(&:to_s).each { |f| require f }

# Ensures that the test database schema matches the current schema file.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Fixtures
  config.fixture_paths = [
    Rails.root.join("spec/fixtures")
  ]

  # Use transactions
  config.use_transactional_fixtures = true

  # Automatically determine spec type
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from backtrace
  config.filter_rails_from_backtrace!

  # Devise helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end