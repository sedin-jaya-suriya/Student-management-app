FROM ruby:4.0.5

# Install essential Linux packages
RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs sqlite3 libsqlite3-dev

# Set working directory
WORKDIR /app

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Normalize line endings and ensure executable permissions
RUN sed -i 's/\r$//' bin/render-entrypoint.sh bin/rails bin/setup 2>/dev/null || true
RUN chmod +x bin/*

# Expose port 3000
EXPOSE 3000

# The default command is usually overridden in docker-compose, but we provide a sensible default
CMD ["bin/render-entrypoint.sh"]
