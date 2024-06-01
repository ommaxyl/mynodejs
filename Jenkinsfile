pipeline{
  agent any
  tools{
    maven 'Maven'
  }
  stages{
    stage('Initial stage'){
      steps{
        script{
          sh 'echo Welcome to this program'
          sh 'git clone https://github.com/ommaxyl/mynodejs.git'
        }
      }
    }
    stage('build image'){
      steps{
        script{
          sh 'echo working on building the docker image'
        }
      }
    }
    stage('docker build and Push Image'){
      steps{
        script{
          echo "building the docker image and pushing to dockerhub..."
          withCredentials([usernamePassword(credentialsId: 'dockerhub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
              sh "docker build -t ommaxyl/myapp:${IMAGE_NAME} ."
              sh 'echo $PASS | docker login -u $USER --password-stdin'
              sh "docker push ommaxyl/myapp:${IMAGE_NAME}"
            }
        }
      }
    }
    stage('deploy to ec2'){
      steps{
        script{
          sh 'Deploying the docker image...'
        }
      }
    }
  }
}
