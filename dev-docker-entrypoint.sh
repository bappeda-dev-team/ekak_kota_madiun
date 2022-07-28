#!/bin/sh
set -e

rm -f /app/tmp/pids/server.pid
bundle install

bin/rails db:migrate || bin/rails db:setup
bin/rails yarn:install
