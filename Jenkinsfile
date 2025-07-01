pipeline {
    agent any
    
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
                    dockerImage = docker.build("simple-web-app:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Run Container') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh 'docker stop simple-web-app-container || true'
                    sh 'docker rm simple-web-app-container || true'
                    
                    // Run new container
                    dockerImage.run("--name simple-web-app-container -p 8080:80 -d")
                }
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
            echo 'Cleaning up...'
            sh 'docker stop simple-web-app-container || true'
            sh 'docker rm simple-web-app-container || true'
        }
    }
}
