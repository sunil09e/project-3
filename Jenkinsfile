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
           sh "chmod +x build.sh"
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
                    echo \$PASS | docker login -u \$USER --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
      stage('Deploy') {
       steps {
         sshagent(['keyfile']) {
           script {
            if (env.BRANCH_NAME == 'prod') {
              withCredentials([usernamePassword(
              credentialsId: 'dockerhub-creds',
              usernameVariable: 'USER',
              passwordVariable: 'PASS'
             )]) {
              sh """
              ssh -o StrictHostKeyChecking=no ec2-user@${EC2_IP} '
              echo \$PASS | docker login -u \$USER --password-stdin

              if [ ! -d app ]; then
              git clone https://github.com/sunil09e/project-3.git app
              fi

              cd app &&
              git checkout prod &&
              git pull origin prod &&
              chmod +x deploy.sh &&
              ./deploy.sh ${IMAGE_NAME} ${IMAGE_TAG}
              '
              """
            }
          } else {
            sh """
            ssh -o StrictHostKeyChecking=no ec2-user@${EC2_IP} "
            if [ ! -d app ]; then
             git clone https://github.com/sunil09e/project-3.git app
            fi

            cd app &&
            git checkout dev &&
            git pull origin dev &&
            chmod +x deploy.sh &&
            ./deploy.sh ${IMAGE_NAME} ${IMAGE_TAG}
            "
            """
          }
       }
     }
   }
  }     
 }        
}
