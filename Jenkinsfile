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
                    bat '''
                    echo %DOCKERHUB_PASS% | docker login -u %DOCKERHUB_USER% --password-stdin
                    '''
                }
            }
        }

        stage('Build and Tag Docker Images') {
            steps {
                bat '''
                docker build -t %DOCKER_IMAGE%:latest .
                docker tag %DOCKER_IMAGE%:latest %DOCKER_IMAGE%:build-%BUILD_NUMBER%
                '''
            }
        }

        stage('Push Docker Images') {
            steps {
                retry(3) {
                    bat '''
                    docker push %DOCKER_IMAGE%:latest
                    docker push %DOCKER_IMAGE%:build-%BUILD_NUMBER%
                    '''
                }
            }
        }

        stage('Deploy to Render') {
            steps {
                bat '''
                curl -X POST https://api.render.com/deploy/srv-xxxxxxxxxxx?key=API_KEY
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
