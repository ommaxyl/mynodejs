pipeline{
  agent any
  environment{
      DOCKER_IMAGE = "ommaxyl/myapp:${BUILD_NUMBER}"
      EC2_USER = 'ubuntu'
      EC2_HOST = '54.225.8.63'
      SSH_CREDENTIALS_ID = 'ec2-ssh-key'
  }
  stages{
    stage("test"){
      steps{
        script{
          echo "Testing the Application..."
        }
      }
    }
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
          echo "Deploying the docker image..."
          sshagent([SSH_CREDENTIALS_ID]) {
            sh 'echo "Testing SSH access to ${EC2_HOST}"'
            sh 'ssh -v -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "echo SSH connection established"'
            sh """
            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} << 'EOF'
              docker pull ${DOCKER_IMAGE}
              docker stop \$(docker ps -q --filter ancestor=${DOCKER_IMAGE}) || true
              docker run -d -p 8081:80 ${DOCKER_IMAGE}
            EOF
            """
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

