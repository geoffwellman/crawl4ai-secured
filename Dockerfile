FROM unclecode/crawl4ai:latest

# Switch to root to install packages and set up files
USER root

# Install envsubst for environment variable substitution
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Create crawl4ai directory for appuser (not root)
RUN mkdir -p /home/appuser/.crawl4ai && chown -R appuser:appuser /home/appuser/.crawl4ai

# Copy configuration files
COPY config.yml /app/config.yml
COPY start.sh /start.sh
RUN chmod +x /start.sh && chown appuser:appuser /app/config.yml /start.sh

# Set environment variable to use appuser home for crawl4ai data
ENV CRAWL4AI_HOME=/home/appuser/.crawl4ai

# Switch back to appuser (as per original image)
USER appuser

# Expose the port
EXPOSE 11235

# Use start script as entrypoint
CMD ["/start.sh"]