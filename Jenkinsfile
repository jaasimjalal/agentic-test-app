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
                echo "Building Health API Service..."
            }
        }
        stage('Install') {
            steps {
                dir(env.BUILD_DIR) {
                    sh 'npm ci'
                }
            }
        }
        stage('Test') {
            steps {
                dir(env.BUILD_DIR) {
                    sh 'npm test'
                }
            }
        }
        stage('Build') {
            steps {
                dir(env.BUILD_DIR) {
                    sh 'npm run build'
                }
            }
        }
        stage('Docker Build') {
            steps {
                dir(env.BUILD_DIR) {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }
        stage('Deploy & Verify') {
            steps {
                script {
                    sh '''
                        docker stop ${CONTAINER_NAME} 2>/dev/null || true
                        docker rm ${CONTAINER_NAME} 2>/dev/null || true
                        docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}
                        sleep 3
                        curl -f http://localhost:${PORT}/health
                        docker logs ${CONTAINER_NAME}
                    '''
                }
            }
        }
        stage('Cleanup') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} 2>/dev/null || true
                    docker rm ${CONTAINER_NAME} 2>/dev/null || true
                '''
            }
        }
    }
    post {
        success {
            echo "✅ Health API deployed successfully!"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}