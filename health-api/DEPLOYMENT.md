# Health API Deployment Guide

## Quick Deploy (One Command)

```bash
chmod +x setup.sh
./setup.sh
```

## Manual Deployment Steps

### 1. Setup
```bash
git clone https://github.com/jaasimjalal/agentic-test-app.git
cd agentic-test-app/health-api/backend
```

### 2. Install & Test
```bash
npm ci
npm test
npm run build
```

### 3. Docker Build & Run
```bash
docker build -t health-api .
docker run -d --name health-api -p 3000:3000 health-api
```

### 4. Verify Deployment
```bash
curl http://localhost:3000/health
# Should return: {"status":"healthy", ...}
```

## Jenkins Deployment

1. Access Jenkins dashboard
2. Create new job
3. Select "Pipeline"
4. Use Jenkinsfile from repository root
5. Run build

## Environment

| Service | Port | Health Check |
|---------|------|--------------|
| Health API | 3000 | `curl http://localhost:3000/health` |

## Production Checklist

- [x] TypeScript compiled
- [x] Tests passing
- [x] Docker image built
- [x] Container running
- [x] Health check passing
- [x] Security headers enabled
- [x] CORS configured
- [x] Error handling implemented
- [x] Logging configured

## Troubleshooting

### Container not starting
```bash
docker logs health-api
```

### Port in use
```bash
# Change port mapping
docker run -d --name health-api -p 8080:3000 health-api
```

### Clean restart
```bash
docker stop health-api && docker rm health-api
./setup.sh
```

## API Endpoints

### Health Check
```bash
curl http://localhost:3000/health
```

**Response:**
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

### Service Info
```bash
curl http://localhost:3000/
```

**Response:**
```json
{
  "message": "Health API Service",
  "endpoints": ["/health"],
  "version": "1.0.0"
}
```

## Next Steps

1. Monitor logs: `docker logs -f health-api`
2. Scale if needed: Multiple containers behind load balancer
3. Set up monitoring with health endpoint
4. Configure reverse proxy (Nginx/HAProxy)

---

**Status:** ✅ Ready for production deployment