FROM ruby:4.0.5

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      nodejs \
      postgresql-client \
      libpq-dev \
      && rm -rf /var/lib/apt/lists/*

# Set application directory
WORKDIR /app

# Install Ruby gems first for Docker cache
COPY Gemfile Gemfile.lock ./

RUN bundle install

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

# Remove unnecessary build cache
RUN rm -rf tmp/cache

# Render provides the PORT environment variable
EXPOSE 3000

# Start Rails through the entrypoint
CMD ["bin/render-entrypoint.sh"]