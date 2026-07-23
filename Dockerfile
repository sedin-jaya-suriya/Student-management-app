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

# Expose port 3000
EXPOSE 3000

# The default command is usually overridden in docker-compose, but we provide a sensible default
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
