pipeline {
    agent any

    environment {
        IMAGE_NAME = "simple-web-app"
        CONTAINER_NAME = "simple-web-app-container"
        CONTAINER_PORT = "80"
        HOST_PORT = "8082"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/asadali2004/simple-web-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME%:%BUILD_NUMBER% ."
            }
        }

       stage('Stop and Remove Old Container') {
    steps {
        bat '''
            docker stop %CONTAINER_NAME% >nul 2>&1
            IF %ERRORLEVEL% NEQ 0 (
                echo Container not running or already stopped.
            )
            docker rm %CONTAINER_NAME% >nul 2>&1
            IF %ERRORLEVEL% NEQ 0 (
                echo Container not found or already removed.
            )
            EXIT /B 0
        '''
    }
}

        stage('Run New Container') {
            steps {
                bat """docker run -d --name %CONTAINER_NAME% -p 8081:%PORT% %IMAGE_NAME%:%BUILD_NUMBER%"""
            }
        }
    

        stage('Verify Deployment') {
            steps {
                bat '''
                    timeout /t 5 >nul
                    call verify.bat
                    IF %ERRORLEVEL% NEQ 0 (
                        echo Verification failed!
                        docker logs %CONTAINER_NAME%
                        exit /b 1
                    )
                '''
            }
        }
    }

    post {
        always {
            bat '''
                docker stop %CONTAINER_NAME% >nul 2>&1
                docker rm %CONTAINER_NAME% >nul 2>&1
                echo Cleanup complete.
            '''
        }
    }
}
