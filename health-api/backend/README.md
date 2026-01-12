# Health API Service

A simple, production-ready health check API microservice built with Node.js, TypeScript, and Express.

## Overview

This service provides a RESTful API endpoint for health checks, suitable for container orchestration platforms, monitoring systems, and service discovery.

## Features

- ✅ Health check endpoint (`/health`)
- ✅ Built with TypeScript for type safety
- ✅ Security headers via Helmet
- ✅ CORS enabled
- ✅ Structured logging
- ✅ Centralized error handling
- ✅ Input validation
- ✅ Comprehensive test suite
- ✅ Multi-stage Docker build
- ✅ Production-ready configuration

## API Specification

### Endpoints

| Method | Path | Description | Response |
|--------|------|-------------|----------|
| GET | `/` | Service information | 200 OK |
| GET | `/health` | Health check status | 200 OK |

### Response Examples

#### GET /health
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 1234.56,
  "environment": "development",
  "service": "health-api",
  "version": "1.0.0"
}
```

#### GET /
```json
{
  "message": "Health API Service",
  "endpoints": ["/health"],
  "version": "1.0.0"
}
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `3000` | Server port |
| `NODE_ENV` | `development` | Environment (development/production) |

## Local Development

### Prerequisites
- Node.js 18+
- npm or yarn

### Installation
```bash
cd health-api/backend
npm install
```

### Running the service
```bash
# Development mode with hot reload
npm run dev

# Production mode
npm run build
npm start

# Run tests
npm test
```

### Testing the API
```bash
# Health check
curl http://localhost:3000/health

# Service info
curl http://localhost:3000/
```

## Docker

### Build and run locally
```bash
# Build the image
docker build -t health-api ./health-api/backend

# Run container
docker run -p 3000:3000 health-api
```

### Using docker-compose
```bash
docker-compose up --build
```

## Jenkins CI/CD

The repository includes a Jenkinsfile for automated builds and local testing.

### Jenkins Pipeline Steps
1. Checkout code
2. Install dependencies
3. Run tests
4. Build Docker image
5. Run container locally for verification

## Error Handling

The API uses standard HTTP status codes:
- `200` - Success
- `404` - Not Found
- `500` - Internal Server Error

## Security

- Helmet.js for security headers
- CORS configured for cross-origin requests
- No sensitive data in logs
- Environment-based configuration

## License

MIT