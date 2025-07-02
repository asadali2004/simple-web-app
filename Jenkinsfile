pipeline {
    agent any

    environment {
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
                bat """
                    docker build -t simple-web-app:%BUILD_ID% %DOCKER_BUILD_ARGS%
                """
            }
        }

        stage('Run Container') {
            steps {
                bat """
                    @echo off
                    echo Stopping old container if exists...
                    docker stop simple-web-app-container >nul 2>&1
                    docker rm simple-web-app-container >nul 2>&1

                    echo Starting new container...
                    docker run -d --name simple-web-app-container -p 8081:80 simple-web-app:%BUILD_ID%

                    timeout /t 5 >nul

                    FOR /F %%i IN ('docker inspect -f "{{.State.Running}}" simple-web-app-container') DO (
                        IF "%%i" NEQ "true" (
                            echo ERROR: Container is not running!
                            docker logs simple-web-app-container
                            exit /b 1
                        )
                    )
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                bat """
                    @echo off
                    timeout /t 10 >nul
                    call verify.bat
                    IF %ERRORLEVEL% NEQ 0 (
                        echo ERROR: Verification failed!
                        docker logs simple-web-app-container
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
                docker stop simple-web-app-container >nul 2>&1
                docker rm simple-web-app-container >nul 2>&1
                echo Cleanup complete
            """
        }
    }
}
