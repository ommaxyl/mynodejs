pipeline{
  agent any
  environment{
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
              sh "docker build -t ommaxyl/myapp:${IMAGE_NAME} ."
              sh 'echo $PASS | docker login -u $USER --password-stdin'
              sh "docker push ommaxyl/myapp:${env.BUILD_NUMBER}"
              env.DOCKER_IMAGE = "ommaxyl/myapp:${env.BUILD_NUMBER}"
            }
        }
      }
    }
    stage('deploy to ec2'){
      steps{
        script{
          echo 'Deploying the docker image...'
          sshagent([SSH_CREDENTIALS_ID]) {
            sh """
              ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} << EOF
              docker pull ${DOCKER_IMAGE}
              docker stop \$(docker ps -q --filter ancestor=${DOCKER_IMAGE}) || true
              docker run -d -p 80:80 ${DOCKER_IMAGE}
            EOF
            """
           }
         }
       }
     }
   }
 }

