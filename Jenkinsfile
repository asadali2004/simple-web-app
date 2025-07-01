pipeline {
    agent any
    
    environment {
        DOCKER_HOST = "tcp://localhost:2375"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/asadali2004/simple-web-app.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build with proper Windows path
                    dockerImage = docker.build("simple-web-app:${env.BUILD_ID}", "--force-rm -f ${WORKSPACE}\\Dockerfile ${WORKSPACE}")
                }
            }
        }
        
stage('Run Container') {
    steps {
        script {
            bat '''
                @echo off
                echo Stopping any existing container...
                docker stop simple-web-app-container >nul 2>&1
                docker rm simple-web-app-container >nul 2>&1
                REM Ignore any errors from above and continue
            '''
            bat "docker run --name simple-web-app-container -p 8081:80 -d simple-web-app:${env.BUILD_ID}"
        }
    }
}

        
        stage('Verify Deployment') {
            steps {
                bat 'verify.bat'
            }
        }
    }
}
