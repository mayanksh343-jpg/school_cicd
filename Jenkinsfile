pipeline {
    agent any

    environment {
        FRONTEND_IMAGE = "mayanksh786/school-frontend"
        BACKEND_IMAGE  = "mayanksh786/school-backend"
        TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend Image') {
            steps {
                sh "docker build -t ${BACKEND_IMAGE}:${TAG} ./backend"
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh "docker build -t ${FRONTEND_IMAGE}:${TAG} ./frontend"
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push ${BACKEND_IMAGE}:${TAG}"
                sh "docker push ${FRONTEND_IMAGE}:${TAG}"
            }
        }

       stage('Deploy') {
    steps {
        sh '''
        docker rm -f backend frontend || true

        docker run -d --name backend \
          -p 5000:5000 \
          mayanksh786/school-backend:latest

        docker run -d --name frontend \
          -p 80:80 \
          mayanksh786/school-frontend:latest
        '''
    }


    }

    post {
        always {
            script {
                // safer wrapper prevents FilePath issues
                sh "docker logout || true"
                // fail ho jaya logout toh pipeline fail na karna
            }
        }

        success {
            echo "Pipeline completed successfully!"
        }

        failure {
            echo "Pipeline failed!"
        }
    }
}