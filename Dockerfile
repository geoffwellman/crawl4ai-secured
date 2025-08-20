FROM unclecode/crawl4ai:latest

# Switch to root to install packages
USER root

# Install envsubst for environment variable substitution
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY config.yml /app/config.yml
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the port
EXPOSE 11235

# Use start script as entrypoint
CMD ["/start.sh"]