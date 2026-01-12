#!/bin/bash
set -e
echo "================================================"
echo "🚀 Health API - Local Deployment"
echo "================================================"

PROJECT_DIR="health-api/backend"
cd "$PROJECT_DIR" || exit 1

echo "\n[1/5] Checking prerequisites..."
command -v node >/dev/null 2>&1 || { echo "Node.js required"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker required"; exit 1; }

echo "\n[2/5] Installing dependencies..."
npm ci

echo "\n[3/5] Running tests..."
npm test

echo "\n[4/5] Building..."
npm run build && docker build -t health-api .

echo "\n[5/5] Deploying container..."
docker stop health-api 2>/dev/null || true
docker rm health-api 2>/dev/null || true
docker run -d --name health-api -p 3000:3000 --env NODE_ENV=production health-api

sleep 3

echo "\n✅ Verifying deployment..."
if curl -f http://localhost:3000/health; then
    echo "\n\n🎉 SUCCESS! Health API is live at http://localhost:3000"
    echo "\nTest it: curl http://localhost:3000/health"
else
    echo "❌ FAILED"
    docker logs health-api
    exit 1
fi