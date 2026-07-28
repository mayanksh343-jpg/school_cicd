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
    }
    post {
    always {
        script {
            sh "docker logout || true"
        }
    }

    success {
        emailext(
            subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
Hello Mayank,

Your Jenkins pipeline completed successfully.

Job Name: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
Build URL: ${env.BUILD_URL}

Regards,
Jenkins
""",
            to: "mayanksh343@gmail.com"
        )
    }

    failure {
        emailext(
            subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
     Hello Mayank,

    Your Jenkins pipeline has failed.

    Job Name: ${env.JOB_NAME}
    Build Number: ${env.BUILD_NUMBER}
    Build URL: ${env.BUILD_URL}

    Please check the console output.

    Regards,
    Jenkins
    """,
            to: "mayanksh343@gmail.com"
        )
    }
}
}
