pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'khowshikksharma/healthcaremrs'
        DOCKER_REGISTRY = 'docker.io'
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker tag ${DOCKER_IMAGE} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                    sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                }
            }
        }

        stage('Deploy to Render') {
            steps {
                script {
                    // Deploy to Render API or use their CLI
                    sh 'render deploy --service healthcaremrs'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
