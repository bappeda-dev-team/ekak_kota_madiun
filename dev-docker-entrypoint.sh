#!/bin/sh
set -e

rm -f /app/tmp/pids/server.pid

bin/rails s -b 0.0.0.0
