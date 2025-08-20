#!/bin/bash

# Substitute environment variables in config.yml
envsubst < /app/config.yml > /app/config_final.yml
mv /app/config_final.yml /app/config.yml

# Start the application using supervisord
exec supervisord -c /app/supervisord.conf