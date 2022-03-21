#!/bin/sh
set -e

echo "Environment: $RAILS_ENV"

bundle check || bundle install

rm -f /app/tmp/pids/server.pid

bundle exec ${@}