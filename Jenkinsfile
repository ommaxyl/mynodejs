ho pipeline{
  agent any
  tools{
    maven 'Maven'
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
            }
        }
      }
    }
    stage('deploy to ec2'){
      steps{
        script{
          echo 'Deploying the docker image...'
        }
      }
    }
  }
}
