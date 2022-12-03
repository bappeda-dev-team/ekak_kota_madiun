#!/bin/sh
set -e

rm -f /app/tmp/pids/server.pid
bundle install

bin/rails db:migrate || bin/rails db:setup && bin/rails db:migrate && bin/rails db:seed
bin/rails yarn:install
bin/rails s -b 0.0.0.0
