pipeline{
  agent any
  environment{
      DOCKER_IMAGE = "ommaxyl/myapp:${BUILD_NUMBER}"
      EC2_USER = 'ubuntu'
      EC2_HOST = '54.225.8.63'
      SSH_CREDENTIALS_ID = 'ec2-ssh-key'
  }
  stages{
    stage('docker build and Push Image'){
      steps{
        script{
          echo "building the docker image and pushing to dockerhub..."
          withCredentials([usernamePassword(credentialsId: 'dockerhub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
              sh "docker build -t ${DOCKER_IMAGE} ."
              sh "echo $PASS | docker login -u $USER --password-stdin"
              sh "docker push ${DOCKER_IMAGE}"
            }
         }
       }
    }
    stage('deploy to ec2'){
      steps{
        script{
          def host = '54.225.8.63'
          def prodContainerName = 'productionContainer'
          def remoteUser = 'ubuntu'
                    
          sh "ssh-keyscan -H ${host} >> ~/.ssh/known_hosts"
                     
          sshagent(['ec2-ssh-key']) {
              sh "ssh ${remoteUser}@${host} 'sudo docker pull ${DOCKER_IMAGE}'"
              sh "ssh ${remoteUser}@${host} 'sudo docker stop ${prodContainerName} || true'"
              sh "ssh ${remoteUser}@${host} 'sudo docker rm ${prodContainerName} || true'"
              sh "ssh ${remoteUser}@${host} 'sudo docker run -d --name ${prodContainerName} -p 81:80 ${DOCKER_IMAGE}'"
             }
           }
         }
       }
     }
   post{
    always{
      cleanWs()
    }
  }
}

