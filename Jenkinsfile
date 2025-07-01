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
                script {
                    dockerImage = docker.build(
                        "simple-web-app:${env.BUILD_ID}",
                        "--force-rm -f ${WORKSPACE}/Dockerfile ${WORKSPACE}"
                    )
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    bat '''
                        @echo off
                        echo Cleaning up old container...
                        docker stop simple-web-app-container >nul 2>&1
                        docker rm simple-web-app-container >nul 2>&1

                        echo Running new container...
                        docker run --name simple-web-app-container -p 8081:80 -d simple-web-app:%BUILD_ID%
                        if %errorlevel% neq 0 (
                            echo ERROR: Failed to run the container!
                            docker ps -a
                            exit /b 1
                        ) else (
                            echo Container started successfully.
                        )

                        echo Showing container list...
                        docker ps -a
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                bat '''
                    echo Verifying deployment...
                    verify.bat
                    if %errorlevel% neq 0 (
                        echo ERROR: verify.bat failed!
                        docker logs simple-web-app-container
                        exit /b 1
                    )
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker environment...'
            bat '''
                docker stop simple-web-app-container >nul 2>&1
                docker rm simple-web-app-container >nul 2>&1
                docker image prune -f >nul 2>&1
            '''
        }
    }
}
