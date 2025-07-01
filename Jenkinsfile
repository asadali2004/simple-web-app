pipeline {
    agent any

    /* Uncomment the next line only if your Docker daemon really listens on 2375
    environment {
        DOCKER_HOST = "tcp://localhost:2375"
    }
    */

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
                    /* clean up any previous run but never fail the build */
                    bat '''
                        @echo off
                        echo Cleaning old container...
                        docker stop simple-web-app-container >nul 2>&1
                        docker rm   simple-web-app-container >nul 2>&1
                    '''
                    bat "docker run --name simple-web-app-container -p 8081:80 -d ${dockerImage.getImageName()}"
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
            echo 'Tearing down resources...'
            bat '''
                @echo off
                docker stop simple-web-app-container >nul 2>&1
                docker rm   simple-web-app-container >nul 2>&1
                docker image prune -f      >nul 2>&1
            '''
        }
    }
}
