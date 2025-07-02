pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/asadali2004/simple-web-app.git']]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t simple-web-app:%BUILD_ID% .'
            }
        }

        stage('Run Container') {
            steps {
                bat '''
                    docker stop simple-web-app-container >nul 2>&1
                    docker rm simple-web-app-container >nul 2>&1

                    docker run -d --name simple-web-app-container -p 8081:80 simple-web-app:%BUILD_ID%
                '''
            }
        }
        stage('Verify Deployment') {
    steps {
        bat 'verify.bat'
    }
}

    }

    post {
        always {
            bat '''
                docker stop simple-web-app-container >nul 2>&1
                docker rm simple-web-app-container >nul 2>&1
            '''
        }
    }
}
