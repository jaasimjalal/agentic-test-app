#!/bin/bash

set -e

echo "🚀 Health API Deployment Script"
echo "================================="

# Clone or pull repository
if [ ! -d "agentic-test-app" ]; then
    echo "Cloning repository..."
    git clone https://github.com/jaasimjalal/agentic-test-app.git
    cd agentic-test-app
else
    echo "Repository exists, pulling latest..."
    cd agentic-test-app
    git checkout feature/health-api
    git pull origin feature/health-api
fi

# Navigate to project
cd health-api/backend

echo "\n📦 Installing dependencies..."
npm ci

echo "\n🧪 Running tests..."
npm test

echo "\n🔨 Building application..."
npm run build

echo "\n🐳 Building Docker image..."
docker build -t health-api .

echo "\n🚀 Starting service..."
docker stop health-api 2>/dev/null || true
docker rm health-api 2>/dev/null || true

docker run -d \
    --name health-api \
    -p 3000:3000 \
    --env NODE_ENV=production \
    --env PORT=3000 \
    health-api

echo "\n⏳ Waiting for service to be ready..."
sleep 3

echo "\n✅ Testing health endpoint..."
curl -s http://localhost:3000/health | python3 -m json.tool

echo "\n🎉 Service deployed successfully!"
echo "\n📊 Service available at:"
echo "  - Health: http://localhost:3000/health"
echo "  - Info:   http://localhost:3000/"
echo "\n🔧 Manage service:"
echo "  - View logs: docker logs health-api"
echo "  - Stop:      docker stop health-api"
echo "  - Restart:   docker restart health-api"