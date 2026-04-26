pipeline {
    agent any

    environment {
        IMAGE_TAG = "v${BUILD_NUMBER}"

        EC2_IP = "15.207.248.21"
    }
    
    stages {

      stage('Clone') {
        steps {
           git branch: "${env.BRANCH_NAME}", url: 'https://github.com/sunil09e/project-3.git'
        }
      }
 
      stage('Set Repo') {
        steps {
          script {
              if (env.BRANCH_NAME == 'dev') {
                 env.IMAGE_NAME = "crazy1/dev"
              } else {
                  env.IMAGE_NAME = "crazy1/prod"
              }
          }
        } 
      }

      stage('Build') {
         steps {
           sh "./build.sh ${IMAGE_NAME} ${IMAGE_TAG}"
         }
      }

      stage('Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh """
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
     
      stage('Deploy') {
        steps {
          sshagent(['keyfile']) {
            sh """
            ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
            if [ ! -d app ]; then
            git clone https://github.com/sunil09e/project-3.git app
            fi

            cd app &&
            git checkout ${BRANCH_NAME} &&
            git pull origin ${BRANCH_NAME} &&
            ./deploy.sh ${IMAGE_NAME} ${IMAGE_TAG}
            '	
            """
          }
        }
      }
}

