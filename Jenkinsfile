pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'khowshikksharma/healthcaremrs'
        DOCKER_REGISTRY = 'docker.io'
        NAGIOS_HOST = 'localhost'
        NAGIOS_SERVICE = 'HTTP'
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

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %DOCKER_IMAGE%:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                bat 'docker push %DOCKER_IMAGE%:latest'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to Render') {
            steps {
                bat '''
                curl -X POST https://api.render.com/deploy/srv-xxxxxxxxxxxx?key=YOUR_API_KEY
                '''
            }
        }

        stage('Nagios Check') {
            steps {
                script {
                    def nagios_url = "http://localhost/nagios/cgi-bin/statusjson.cgi?query=service&hostname=${NAGIOS_HOST}&servicedescription=${NAGIOS_SERVICE}"
                    def response = bat(script: "curl -s \"${nagios_url}\"", returnStdout: true).trim()
                    echo "Nagios Response: ${response}"
                    if (!response.contains('"status": "0"')) {
                        error "❌ Nagios Monitoring Check Failed: Service is not OK"
                    }
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
