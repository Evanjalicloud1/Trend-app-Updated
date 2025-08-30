pipeline {
  agent any

  environment {
    IMAGE = "evanjali1468/trend-store:latest"
    DOCKERHUB = credentials('dockerhub-creds')
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Evanjalicloud1/Trend-app-Updated.git', branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t trend-store .'
      }
    }

    stage('Push to DockerHub') {
      steps {
        sh '''
          echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
          docker tag trend-store:latest $IMAGE
          docker push $IMAGE
        '''
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml
        '''
      }
    }
  }
}
