#!/bin/bash

# Set default values for environment variables if not provided
export RATE_LIMIT="${RATE_LIMIT:-10/minute}"

# Substitute environment variables in config.yml
envsubst < /app/config.yml > /app/config_final.yml
mv /app/config_final.yml /app/config.yml

# Debug: show the final config (remove this after debugging)
echo "=== FINAL CONFIG ==="
cat /app/config.yml
echo "=== END CONFIG ==="

# Start the application using supervisord
exec supervisord -c /app/supervisord.conf