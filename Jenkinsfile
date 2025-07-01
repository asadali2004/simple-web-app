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
                    // Gracefully stop and remove any existing container
                    bat '''
                        docker stop simple-web-app-container 2> nul || echo "No running container to stop"
                        docker rm simple-web-app-container 2> nul || echo "No container to remove"
                    '''
                    
                    // Run new container with health check
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
    
    post {
        always {
            echo 'Cleaning up...'
            bat '''
                docker stop simple-web-app-container 2> nul || echo "No container to stop"
                docker rm simple-web-app-container 2> nul || echo "No container to remove"
            '''
        }
    }
}
