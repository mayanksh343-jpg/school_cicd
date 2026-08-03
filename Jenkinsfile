pipeline {
    agent any

    environment {
        FRONTEND_IMAGE = "mayanksh786/school-frontend"
        BACKEND_IMAGE  = "mayanksh786/school-backend"
        TAG = "$BUILD_NUMBER"
    }

    stages {

        stage('Clean Workspace') {
          steps {
           cleanWs()
          }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Images') {
    steps {
        sh '''
        docker build -t ${BACKEND_IMAGE}:${TAG} ./backend
        docker build -t ${FRONTEND_IMAGE}:${TAG} ./frontend
        '''
    }
}
        

        stage('Security Scan') {
          steps {
            sh '''
               trivy image ${BACKEND_IMAGE}:${TAG}
                trivy image ${FRONTEND_IMAGE}:${TAG}
               '''
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
        sh '''
        docker push ${BACKEND_IMAGE}:${TAG}
        docker push ${FRONTEND_IMAGE}:${TAG}

        docker tag ${BACKEND_IMAGE}:${TAG} ${BACKEND_IMAGE}:latest
        docker tag ${FRONTEND_IMAGE}:${TAG} ${FRONTEND_IMAGE}:latest

        docker push ${BACKEND_IMAGE}:latest
        docker push ${FRONTEND_IMAGE}:latest
        '''
    }
}

     stage('Deploy') {
       steps {
        sh '''
        docker compose down

        docker compose pull

        docker compose up -d
        '''  
     }
    }

    stage('Health Check') {
    steps {
        sh '''
        sleep 15

        curl -f http://localhost:5000 || exit 1
        curl -f http://localhost || exit 1
        '''
    }
}



    stage('Cleanup') {
    steps {
        sh '''
        docker image prune -f
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
        to: "mayanksh343@gmail.com",
        subject: "SUCCESS",
        body: "Pipeline Success"
    )
}

failure {
    emailext(
        to: "mayanksh343@gmail.com",
        subject: "FAILED",
        body: "Pipeline Failed"
    )
}
    
}
}
