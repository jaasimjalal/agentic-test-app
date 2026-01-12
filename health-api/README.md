# Health API Service

## Architecture Overview

```
┌─────────────────────────────────────┐
│         Health API Service          │
├─────────────────────────────────────┤
│                                     │
│  Express.js (Node.js/TypeScript)   │
│                                     │
│  ┌────────────────────────────┐    │
│  │  REST Endpoints:           │    │
│  │  - GET /health             │    │
│  │  - GET /                   │    │
│  └────────────────────────────┘    │
│                                     │
│  Security: Helmet, CORS             │
│  Validation: Express middleware    │
│  Logging: Structured console       │
└─────────────────────────────────────┘


## API Specification

### Endpoints

| Method | Path      | Description                 | Status | Auth |
|--------|-----------|-----------------------------|--------|------|
| GET    | `/`       | Service information         | 200    | None |
| GET    | `/health` | Health check with metrics   | 200    | None |

### Schemas

#### Health Response (GET /health)
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

#### Info Response (GET /)
```json
{
  "message": "Health API Service",
  "endpoints": ["/health"],
  "version": "1.0.0"
}
```

### Error Responses

#### 404 Not Found
```json
{
  "error": "Not Found",
  "path": "/unknown",
  "method": "GET"
}
```

#### 500 Internal Server Error
```json
{
  "error": "Internal Server Error",
  "message": "Error details",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

## Environment Variables

| Variable | Default | Required | Description |
|----------|---------|----------|-------------|
| `PORT` | `3000` | No | Server listening port |
| `NODE_ENV` | `development` | No | Runtime environment |

## Local Development

### Prerequisites
- Node.js 18+ (LTS recommended)
- npm or yarn
- Docker (optional, for containerization)

### Quick Start

```bash
# 1. Navigate to project
cd health-api/backend

# 2. Install dependencies
npm install

# 3. Copy environment file
cp .env.example .env

# 4. Run in development mode
npm run dev

# 5. Test the API (in another terminal)
curl http://localhost:3000/health
```

### Development Commands

```bash
# Run development server (hot reload)
npm run dev

# Build for production
npm run build

# Start production server
npm start

# Run tests
npm test

# Run tests with coverage
npm test -- --coverage
```

## Docker

### Build and Run

```bash
# From the repository root
cd health-api/backend

# Build the image
docker build -t health-api .

# Run container
docker run -p 3000:3000 health-api

# Run with custom port
docker run -p 8080:3000 -e PORT=3000 health-api
```

### Using the deployment script

```bash
# Make executable
chmod +x deploy-local.sh

# Run deployment
./deploy-local.sh
```

## Jenkins Pipeline

The Jenkinsfile at repository root automates:
1. **Dependency Installation**: `npm ci`
2. **Testing**: Jest test suite
3. **Build**: TypeScript compilation
4. **Docker Build**: Container image creation
5. **Local Run**: Container execution
6. **Health Check**: API verification
7. **Cleanup**: Resource management

### Pipeline Stages

```groovy
Checkout → Install → Test → Build → Docker → Run → Cleanup
```

## Example API Requests

### Health Check
```bash
curl -s http://localhost:3000/health | jq
```

### Service Info
```bash
curl -s http://localhost:3000/ | jq
```

### Using HTTPie
```bash
http GET localhost:3000/health
```

### Error Testing
```bash
curl -i http://localhost:3000/nonexistent
```

## Testing

### Unit Tests
```bash
# Run all tests
npm test

# Watch mode
npm test -- --watch

# Specific test file
npm test -- health.test.ts
```

### Integration Tests

The test suite includes:
- Health endpoint validation
- Service info endpoint
- 404 handling
- Response schema verification

## Production Considerations

### Security
- Helmet.js provides security headers
- CORS configured for controlled access
- No sensitive data in logs
- Environment-based configuration only

### Monitoring
- Health endpoint returns:
  - Service status
  - Uptime metrics
  - Timestamp
  - Environment info

### Scaling
- Stateless design
- Horizontal scaling ready
- Container-optimized
- Minimal resource footprint

### Load Balancing
- Health endpoint suitable for LB checks
- Returns 200 OK when healthy
- Quick response time

## Troubleshooting

### Port Already in Use
```bash
# Change port
PORT=3001 npm run dev
```

### Docker Build Fails
```bash
# Check Docker version
docker --version

# Clean cache
docker system prune -a
```

### Tests Fail
```bash
# Clear node_modules
rm -rf node_modules package-lock.json
npm install
```

## Project Structure

```
health-api/backend/
├── src/
│   ├── server.ts          # Main application
│   └── tests/
│       └── health.test.ts # Test suite
├── dist/                  # Compiled output
├── .env.example          # Environment template
├── Dockerfile            # Multi-stage build
├── docker-compose.yml    # Local orchestration
├── jest.config.js        # Test configuration
├── package.json          # Dependencies
├── tsconfig.json         # TypeScript config
└── README.md            # This file
```

## License

MIT

## Support

For issues or questions, check the logs:
```bash
docker logs health-api
```
