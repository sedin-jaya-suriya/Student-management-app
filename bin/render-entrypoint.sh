#!/usr/bin/env bash

set -e

echo "Preparing the production database..."

bundle exec rails db:prepare

echo "Starting Rails server..."

exec bundle exec rails server \
  -b 0.0.0.0 \
  -p "${PORT:-3000}"