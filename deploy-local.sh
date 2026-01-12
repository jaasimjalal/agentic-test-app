#!/bin/bash

set -e

echo "================================================"
echo "Health API - Local Deployment Script"
echo "================================================"

# Configuration
PROJECT_DIR="health-api/backend"
IMAGE_NAME="health-api"
CONTAINER_NAME="health-api"
PORT="3000"

# Navigate to project directory
cd "$PROJECT_DIR" || exit 1

echo "\n[1/5] Checking dependencies..."
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed"
    exit 1
fi

echo "[2/5] Installing dependencies..."
npm ci

echo "\n[3/5] Running tests..."
npm test

echo "\n[4/5] Building application..."
npm run build

echo "\n[5/5] Building Docker image..."
docker build -t $IMAGE_NAME .

# Stop existing container
echo "\nStopping existing container if running..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "\nStarting container..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:$PORT \
    --env NODE_ENV=production \
    --env PORT=$PORT \
    $IMAGE_NAME

echo "\nWaiting for service to be ready..."
sleep 3

echo "\nPerforming health check..."
if curl -f http://localhost:$PORT/health; then
    echo "\n\n✅ SUCCESS! Health API is running on http://localhost:$PORT"
    echo "\nTest endpoints:"
    echo "  curl http://localhost:$PORT/health"
    echo "  curl http://localhost:$PORT/"
    echo "\nView logs: docker logs $CONTAINER_NAME"
    echo "Stop service: docker stop $CONTAINER_NAME"
else
    echo "\n❌ FAILED! Health check failed."
    echo "\nDocker logs:"
    docker logs $CONTAINER_NAME
    exit 1
fi