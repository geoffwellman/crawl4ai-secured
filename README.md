# Secured Crawl4AI Railway Template

A production-ready deployment of [Crawl4AI](https://github.com/unclecode/crawl4ai) with JWT authentication, rate limiting, and security features.

## Features

- 🔐 **JWT Authentication** - Secure API access with token-based authentication
- 🚦 **Rate Limiting** - Configurable request limits per user
- 🔒 **HTTPS Ready** - Automatic HTTPS redirect support
- 📊 **Monitoring** - Built-in health checks and Prometheus metrics
- 🚀 **One-Click Deploy** - Easy deployment to Railway

## Quick Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/crawl4ai-secured)

## Configuration

### Required Environment Variables

- `JWT_SECRET_KEY` - Secret key for JWT tokens (auto-generated on first deploy)

### Optional Environment Variables

- `OPENAI_API_KEY` - For LLM-based extraction features
- `RATE_LIMIT` - API rate limit (default: "10/minute")
- `JWT_EXPIRE_MINUTES` - Token expiration time (default: 30)
- `LOG_LEVEL` - Logging verbosity (default: "INFO")

## Usage

### 1. Get Authentication Token

```bash
curl -X POST "https://your-app.railway.app/token" \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com"}'
```

Response:
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "bearer"
}
```

### 2. Make Authenticated Requests

```bash
curl -X POST "https://your-app.railway.app/crawl" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": ["https://example.com"],
    "word_count_threshold": 10,
    "extract_rules": {
      "title": "//title/text()",
      "description": "//meta[@name='description']/@content"
    }
  }'
```

## API Endpoints

### Public Endpoints
- `GET /health` - Health check
- `GET /metrics` - Prometheus metrics
- `POST /token` - Get authentication token

### Protected Endpoints (Require JWT)
- `POST /crawl` - Crawl URLs and extract data
- `POST /crawl_sync` - Synchronous crawling
- `POST /crawl_async` - Asynchronous crawling
- `GET /task/{task_id}` - Check async task status

## Security Features

1. **JWT Authentication**
   - Tokens expire after 30 minutes by default
   - Secure secret key generation
   - Bearer token authentication

2. **Rate Limiting**
   - Default: 10 requests per minute
   - Configurable per deployment
   - Memory-based storage

3. **HTTPS Support**
   - Automatic redirect from HTTP
   - Secure headers included

## Local Development

```bash
# Clone the repository
git clone https://github.com/your-username/crawl4ai-secured
cd crawl4ai-secured

# Build and run with Docker
docker build -t crawl4ai-secured .
docker run -p 8020:8020 \
  -e JWT_SECRET_KEY="your-secret-key" \
  crawl4ai-secured
```

## Example: Web Scraping with Authentication

```python
import requests
import json

# Get token
token_response = requests.post(
    "https://your-app.railway.app/token",
    json={"email": "user@example.com"}
)
token = token_response.json()["access_token"]

# Crawl website
headers = {"Authorization": f"Bearer {token}"}
crawl_response = requests.post(
    "https://your-app.railway.app/crawl",
    headers=headers,
    json={
        "urls": ["https://example.com"],
        "screenshot": True,
        "extract_rules": {
            "title": "//title/text()",
            "links": "//a/@href"
        }
    }
)

print(json.dumps(crawl_response.json(), indent=2))
```

## Support

- [Crawl4AI Documentation](https://docs.crawl4ai.com)
- [Report Issues](https://github.com/your-username/crawl4ai-secured/issues)

## License

This template is provided under the MIT License. Crawl4AI is licensed under its own terms.