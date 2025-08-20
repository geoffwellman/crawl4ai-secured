#!/bin/bash

# Set default values for environment variables if not provided
export RATE_LIMIT="${RATE_LIMIT:-10/minute}"
export JWT_EXPIRE_MINUTES="${JWT_EXPIRE_MINUTES:-30}"
export LOG_LEVEL="${LOG_LEVEL:-INFO}"
export LLM_PROVIDER="${LLM_PROVIDER:-openai/gpt-4o-mini}"
export LLM_API_KEY_ENV="${LLM_API_KEY_ENV:-OPENAI_API_KEY}"
export LLM_TEMPERATURE="${LLM_TEMPERATURE:-0.7}"
export LLM_MAX_TOKENS="${LLM_MAX_TOKENS:-2000}"
export LLM_BASE_URL="${LLM_BASE_URL:-}"

# JWT_SECRET_KEY should be provided by Railway, but ensure it exists
if [ -z "$JWT_SECRET_KEY" ]; then
  echo "ERROR: JWT_SECRET_KEY is not set!"
  exit 1
fi

# Substitute environment variables in config.yml
envsubst < /app/config.yml > /app/config_final.yml
mv /app/config_final.yml /app/config.yml

# Debug: show the final config (remove this after debugging)
echo "=== FINAL CONFIG ==="
cat /app/config.yml
echo "=== END CONFIG ==="

# Start the application using supervisord
exec supervisord -c /app/supervisord.conf