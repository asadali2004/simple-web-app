pipeline {
    agent any
    environment {
        IMAGE_NAME     = "simple-web-app"
        CONTAINER_NAME = "simple-web-app-container"
        PORT           = "8082"          // single source of truth
    }

    stages {
        stage('Checkout')       { steps { git url: 'https://github.com/asadali2004/simple-web-app.git', branch: 'main' } }
        stage('Build Image')    { steps { bat "docker build -t %IMAGE_NAME%:%BUILD_NUMBER% ." } }

        // stage('Replace Old')    {
        //     steps {
        //         bat 'docker stop %CONTAINER_NAME% >nul 2>&1 || echo not running'
        //         bat 'docker rm   %CONTAINER_NAME% >nul 2>&1 || echo already removed'
        //     }
        // }

        stage('Run Container')  {
            steps {
                bat "docker run -d --name %CONTAINER_NAME% -p %PORT%:80 %IMAGE_NAME%:%BUILD_NUMBER%"
                bat '''
                    timeout /t 3 >nul
                    docker inspect -f "{{.State.Running}}" %CONTAINER_NAME% | findstr true >nul
                    if %errorlevel% neq 0 (
                        echo ERROR: container died!
                        docker logs %CONTAINER_NAME%
                        exit /b 1
                    )
                '''
            }
        }

        stage('Verify') {
            steps {
                bat '''
                    timeout /t 5 >nul
                    curl -s http://localhost:%PORT% > resp.html
                    findstr /I "Welcome to My Simple Web App" resp.html >nul
                    if %errorlevel% neq 0 (
                        echo Verification failed
                        type resp.html
                        exit /b 1
                    )
                    echo Verification OK
                '''
            }
        }
    }
}
