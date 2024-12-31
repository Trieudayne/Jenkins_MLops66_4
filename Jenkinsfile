pipeline {
    agent any

    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'WEBHOOK_TRIGGER', value: '$.trigger', defaultValue: '']
            ],
            causeString: 'Triggered by webhook',
            token: 'trieu_ne',
            printContributedVariables: true,
            printPostContent: true
        )
    }

    options {
        skipDefaultCheckout() // Prevent automatic checkout
    }

    stages {
        stage('Start Pipeline') {
            steps {
                withChecks('Run FastAPI App') {
                    publishChecks name: 'Run FastAPI App', status: 'IN_PROGRESS', summary: 'Pipeline execution has started.'
                }
            }
        }

        stage('Clone Repository') {
            steps {
                git branch: "main", url: 'https://github.com/Trieudayne/Jenkins_MLops66_4.git'
            }
        }

        stage('Run FastAPI Application') {
            steps {
                script {
                    try {
                        bat '''
                        REM Check if the container already exists
                        docker ps -a --format "{{.Names}}" | findstr "api_running" >nul && (
                            echo "Container 'api_running' already exists. Removing it..."
                            docker stop api_running
                            docker rm -f api_running
                        )

                        REM Remove existing Docker image
                        docker images | findstr "api" >nul && (
                            echo "Removing existing Docker image..."
                            docker rmi -f api
                        )

                        REM Build and run the FastAPI container
                        echo "Building the Docker image..."
                        docker build -t api .

                        echo "Running the Docker container..."
                        docker run --name api_running -p 80:80 -d api
                        '''

                        withChecks('Run FastAPI App') {
                            publishChecks name: 'Run FastAPI App', status: 'COMPLETED', conclusion: 'SUCCESS',
                                         summary: 'FastAPI container built and running successfully.'
                        }
                    } catch (e) {
                        withChecks('Run FastAPI App') {
                            publishChecks name: 'Run FastAPI App', status: 'COMPLETED', conclusion: 'FAILURE',
                                         summary: 'Pipeline failed while running the FastAPI container.'
                        }
                        throw e
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    try {
                        bat '''
                        REM Run tests
                        pytest --junitxml=test-results.xml
                        '''
                        withChecks('Run Tests') {
                            publishChecks name: 'Run Tests', status: 'COMPLETED', conclusion: 'SUCCESS',
                                         summary: 'All tests passed successfully.'
                        }
                    } catch (e) {
                        withChecks('Run Tests') {
                            publishChecks name: 'Run Tests', status: 'COMPLETED', conclusion: 'FAILURE',
                                         summary: 'Some tests failed.'
                        }
                        throw e
                    }
                }
            }
        }
    }

    post {
        always {
            withChecks('Run FastAPI App') {
                publishChecks name: 'Run FastAPI App', status: 'COMPLETED', conclusion: 'NEUTRAL',
                             summary: 'Pipeline has completed execution.'
            }
        }
    }
}
