#!/bin/bash
echo "================================================"
echo "🔧 Jenkins Setup for Health API"
echo "================================================"

command -v docker >/dev/null 2>&1 || { echo "Docker required"; exit 1; }

if docker ps -a | grep -q jenkins; then
    echo "Starting existing Jenkins..."
    docker start jenkins
else
    echo "Creating Jenkins container..."
    docker run -d \
        --name jenkins \
        -p 8080:8080 -p 50000:50000 \
        -v jenkins_home:/var/jenkins_home \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $(pwd):/home/workspace \
        jenkins/jenkins:lts
    
    echo "\nJenkins starting at http://localhost:8080"
    echo "Initial password: docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
fi