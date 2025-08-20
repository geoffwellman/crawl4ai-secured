# Secured Crawl4AI Railway Template

A production-ready deployment of [Crawl4AI](https://github.com/unclecode/crawl4ai) with JWT authentication, rate limiting, and security features.

## Features

- 🔐 **JWT Authentication** - Secure API access with token-based authentication
- 🚦 **Rate Limiting** - Configurable request limits per user
- 🔒 **HTTPS Ready** - Automatic HTTPS redirect support
- 📊 **Monitoring** - Built-in health checks and Prometheus metrics
- 🚀 **One-Click Deploy** - Easy deployment to Railway

## Quick Deploy

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/thK2pn?referralCode=1lMTUi)

### Important: Port Configuration

After deploying, you need to configure the port in Railway:

1. Go to your service settings in Railway
2. Under "Networking" → "Public Networking"
3. Set the port to `11234`
4. Save and redeploy

This is required because Crawl4AI runs on a fixed port.

## Configuration

### Required Environment Variables

- `JWT_SECRET_KEY` - Secret key for JWT tokens (auto-generated on first deploy)

### Optional Environment Variables

#### LLM Configuration
- `LLM_PROVIDER` - LLM model to use (default: "openai/gpt-4o-mini")
  - OpenAI: `openai/gpt-5-mini`, `openai/gpt-4o`, `openai/gpt-4o-mini`
  - Anthropic: `anthropic/claude-sonnet-4`, `anthropic/claude-3-5-sonnet-20241022`, `anthropic/claude-3-opus-20240229`
  - Google: `gemini/gemini-1.5-pro`, `gemini/gemini-1.5-flash`
  - Groq: `groq/llama3-70b-8192`, `groq/mixtral-8x7b-32768`
  - Ollama: `ollama/llama3.3`, `ollama/qwen2` (requires `LLM_BASE_URL`)
- `LLM_API_KEY_ENV` - Name of the API key env var (default: "OPENAI_API_KEY")
- `LLM_BASE_URL` - Custom LLM endpoint (e.g., "http://localhost:11434" for Ollama)
- `LLM_TEMPERATURE` - Response randomness 0.0-1.0 (default: 0.7)
- `LLM_MAX_TOKENS` - Max response tokens (default: 2000)

#### API Keys (set based on your LLM_PROVIDER)
- `OPENAI_API_KEY` - OpenAI API key
- `ANTHROPIC_API_KEY` - Anthropic API key
- `GROQ_API_KEY` - Groq API key
- `GEMINI_API_KEY` - Google Gemini API key

#### Other Settings
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

## Example: Using Different LLM Providers

The template supports multiple LLM providers. Simply set the `LLM_PROVIDER` environment variable:

```bash
# OpenAI GPT-5 Mini (latest)
LLM_PROVIDER=openai/gpt-5-mini
OPENAI_API_KEY=sk-your-key

# Anthropic Claude Sonnet 4 (latest)
LLM_PROVIDER=anthropic/claude-sonnet-4
ANTHROPIC_API_KEY=your-anthropic-key

# Google Gemini
LLM_PROVIDER=gemini/gemini-1.5-pro
GEMINI_API_KEY=your-gemini-key

# Groq (fast inference)
LLM_PROVIDER=groq/llama3-70b-8192
GROQ_API_KEY=your-groq-key

# Local Ollama
LLM_PROVIDER=ollama/llama3.3
LLM_BASE_URL=http://localhost:11434
```

Then use LLM extraction in your requests:

```python
crawl_response = requests.post(
    "https://your-app.railway.app/crawl",
    headers=headers,
    json={
        "urls": ["https://example.com"],
        "extraction_strategy": {
            "type": "llm",
            "instruction": "Extract all product names and prices",
            "schema": {
                "type": "object",
                "properties": {
                    "products": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "name": {"type": "string"},
                                "price": {"type": "string"}
                            }
                        }
                    }
                }
            }
        }
    }
)
```

## Support

- [Crawl4AI Documentation](https://docs.crawl4ai.com)
- [Report Issues](https://github.com/your-username/crawl4ai-secured/issues)

## License

This template is provided under the MIT License. Crawl4AI is licensed under its own terms.