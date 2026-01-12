# Health API Service

## Quick Start

```bash
# 1. Install & Run locally
cd health-api/backend
npm install
npm run dev

# 2. Test the API
curl http://localhost:3000/health
```

## Docker Deployment

```bash
docker build -t health-api ./health-api/backend
docker run -p 3000:3000 health-api
```

## Jenkins Pipeline

The `Jenkinsfile` at repository root will:
1. Install dependencies
2. Run tests
3. Build Docker image
4. Run container & verify health

## API Endpoints

- `GET /` - Service info
- `GET /health` - Health status (returns 200)

## Example Response

```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 1234.56,
  "environment": "production",
  "service": "health-api",
  "version": "1.0.0"
}
```