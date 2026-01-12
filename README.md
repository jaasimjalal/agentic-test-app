# Agentic Test App

Repository containing microservices and test applications.

## Projects

- [Health API Service](health-api/backend/) - Simple health check API microservice

## Quick Start

### Health API Service

```bash
# Local development
cd health-api/backend
npm install
npm run dev

# Docker deployment
cd health-api/backend
docker build -t health-api .
docker run -p 3000:3000 health-api

# Automated deployment
chmod +x deploy-local.sh
./deploy-local.sh
```

### API Endpoints

- `GET /health` - Health status with metrics
- `GET /` - Service information

## Jenkins CI/CD

Run the Jenkinsfile for automated build and testing:
- Dependency installation
- Test execution
- Docker image build
- Container deployment
- Health verification

## Documentation

See individual project README.md files for detailed documentation.