#!/bin/bash

echo "================================================"
echo "🚀 Health API - Automated Deployment"
echo "================================================"

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

info "Starting deployment..."

# Install dependencies & test
cd health-api/backend

info "[1/5] Installing dependencies..."
npm ci

info "[2/5] Running tests..."
npm test

info "[3/5] Building TypeScript..."
npm run build

info "[4/5] Building Docker image..."
docker build -t health-api .

info "[5/5] Running container..."
docker stop health-api 2>/dev/null || true
docker rm health-api 2>/dev/null || true

docker run -d --name health-api -p 3000:3000 --env NODE_ENV=production health-api

sleep 3

info "Health check..."
if curl -f http://localhost:3000/health > /dev/null 2>&1; then
    info "✅ SUCCESS! Health API deployed at http://localhost:3000"
    echo "\nResponse:"
    curl -s http://localhost:3000/health | jq .
else
    error "Failed! Logs:"
    docker logs health-api
fi