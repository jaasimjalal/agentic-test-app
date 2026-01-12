pipeline {
    agent any
    
    environment {
        IMAGE_NAME = 'health-api'
        CONTAINER_NAME = 'health-api-test'
        PORT = '3000'
        BUILD_DIR = 'health-api/backend'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    echo "Branch: ${env.BRANCH_NAME}"
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                dir(env.BUILD_DIR) {
                    sh '''
                        echo "Installing dependencies..."
                        npm ci
                    '''
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                dir(env.BUILD_DIR) {
                    sh '''
                        echo "Running tests..."
                        npm test
                    '''
                }
            }
        }
        
        stage('Build Application') {
            steps {
                dir(env.BUILD_DIR) {
                    sh '''
                        echo "Building TypeScript..."
                        npm run build
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                dir(env.BUILD_DIR) {
                    sh """
                        echo "Building Docker image: ${IMAGE_NAME}..."
                        docker build -t ${IMAGE_NAME} .
                    """
                }
            }
        }
        
        stage('Run Container Locally') {
            steps {
                script {
                    // Stop existing container if running
                    sh '''
                        docker stop ${CONTAINER_NAME} 2>/dev/null || true
                        docker rm ${CONTAINER_NAME} 2>/dev/null || true
                    '''
                    
                    // Run container
                    sh """
                        echo "Starting container: ${CONTAINER_NAME}"
                        docker run -d \
                            --name ${CONTAINER_NAME} \
                            -p ${PORT}:${PORT} \
                            --env NODE_ENV=production \
                            --env PORT=${PORT} \
                            ${IMAGE_NAME}
                    """
                    
                    // Wait for container to be ready
                    sh '''
                        echo "Waiting for container to be ready..."
                        sleep 5
                    '''
                    
                    // Health check
                    sh '''
                        echo "Performing health check..."
                        curl -f http://localhost:${PORT}/health || exit 1
                    '''
                    
                    // Show logs
                    sh '''
                        echo "Container logs:"
                        docker logs ${CONTAINER_NAME}
                    '''
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    sh '''
                        echo "Stopping and removing container..."
                        docker stop ${CONTAINER_NAME} 2>/dev/null || true
                        docker rm ${CONTAINER_NAME} 2>/dev/null || true
                    '''
                }
            }
            post {
                always {
                    echo "Cleanup completed"
                }
            }
        }
    }
    
    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
        always {
            echo "Build finished"
            // Cleanup any running containers
            sh '''
                docker stop ${CONTAINER_NAME} 2>/dev/null || true
                docker rm ${CONTAINER_NAME} 2>/dev/null || true
            '''
        }
    }
}