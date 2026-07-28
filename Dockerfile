FROM ruby:4.0.5

# Install required system packages
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      nodejs \
      libpq-dev \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set the application directory
WORKDIR /app

# Copy Gem files first
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle config set without "development test" && \
    bundle install

# Copy the complete Rails application
COPY . .

# Fix Windows CRLF line endings
RUN sed -i 's/\r$//' \
      bin/rails \
      bin/rake \
      bin/setup \
      bin/render-entrypoint.sh \
      2>/dev/null || true

# Make Rails scripts executable
RUN chmod +x bin/*

# Precompile CSS and JavaScript assets
RUN SECRET_KEY_BASE_DUMMY=1 \
    RAILS_ENV=production \
    bundle exec rails assets:precompile

# Render provides the PORT environment variable
EXPOSE 3000

# Start the Rails application
CMD ["bin/render-entrypoint.sh"]