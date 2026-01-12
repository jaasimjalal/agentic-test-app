# 🚀 Deployment Guide

## Quick Deploy (Local)

```bash
# From repository root
chmod +x run-deployment.sh
./run-deployment.sh
```

## Docker Manual

```bash
cd health-api/backend
docker build -t health-api .
docker run -d --name health-api -p 3000:3000 health-api
curl http://localhost:3000/health
```

## Jenkins Setup

```bash
chmod +x setup-jenkins.sh
./setup-jenkins.sh
```

Then in Jenkins UI:
1. Create pipeline job
2. Point to GitHub repo
3. Use Jenkinsfile

## Current Status

✅ Code: Committed to GitHub
✅ Tests: Included
✅ Docker: Ready
✅ Jenkinsfile: At repository root

## Verify Deployment

```bash
docker ps
# Should show health-api container

curl http://localhost:3000/health
# Should return healthy status
```