pipeline {
    agent any

    environment {
        // Force consistent path handling
        DOCKER_BUILD_ARGS = "--force-rm -f ${WORKSPACE}\\Dockerfile ${WORKSPACE}"
    }

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
                    // Explicit build with Windows paths
                    bat """
                        docker build -t simple-web-app:${env.BUILD_ID} ${DOCKER_BUILD_ARGS}
                    """
                }
            }
        }

stage('Run Container') {
    steps {
        script {
            bat """
                @echo off
                echo [1/3] Stopping old container...
                docker stop simple-web-app-container >nul 2>&1 && (
                    echo Stopped container
                    docker rm simple-web-app-container >nul 2>&1 && echo Removed container
                ) || echo No existing container found

                echo [2/3] Starting new container...
                docker run --name simple-web-app-container -p 8081:80 -d simple-web-app:${env.BUILD_ID}

                echo [3/3] Checking if container is running...
                timeout /t 5 >nul

                docker inspect -f "{{.State.Running}}" simple-web-app-container | find "true" >nul
                if %errorlevel% neq 0 (
                    echo ERROR: Container is not running!
                    docker logs simple-web-app-container  <-- **THIS IS WHAT WE NEED!**
                    exit /b 1
                )

                echo Container started successfully and is running.
            """
        }
    }
}


        stage('Verify Deployment') {
            steps {
                bat """
                    @echo off
                    echo Waiting for application to start...
                    timeout /t 10 >nul
                    verify.bat
                   if %errorlevel% neq 0 (
                    echo ERROR: Verification failed!
                    docker logs simple-web-app-container <-- **ALSO LOOK HERE!**
                    exit /b 1
                )
                """
            }
        }
    }

    post {
        always {
            bat """
                @echo off
                echo Cleaning up containers...
                docker stop simple-web-app-container >nul 2>&1 || echo No container to stop
                docker rm simple-web-app-container >nul 2>&1 || echo No container to remove
                echo Cleanup complete
            """
        }
    }
}
