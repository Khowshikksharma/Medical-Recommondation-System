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

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:latest .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker push ${DOCKER_IMAGE}:latest'
                }
            }
        }

        stage('Deploy to Render') {
            steps {
                script {
                    // Replace with your actual Render API endpoint, service ID and API Key
                    sh 'curl -X POST https://api.render.com/deploy/srv-xxxxxxxxxxx?key=API_KEY'
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
