#!/bin/bash

# Set default values for environment variables if not provided
export RATE_LIMIT="${RATE_LIMIT:-10/minute}"
export PORT="${PORT:-11235}"

# Substitute environment variables in config.yml
envsubst < /app/config.yml > /app/config_final.yml
mv /app/config_final.yml /app/config.yml

# Start the application using supervisord
exec supervisord -c /app/supervisord.conf