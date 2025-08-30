Trend App Deployment - End to End CI/CD on AWS EKS

This project demonstrates deploying a React application to a production-ready Kubernetes cluster on AWS (EKS) using Docker, Terraform, Jenkins, Prometheus, and Grafana.
Steps Completed
1. Clone Application Repository

We cloned the given React application repo and verified it runs on port 3000.

git clone https://github.com/Vennilavan12/Trend.git
cd Trend
2. Dockerization

Created a Dockerfile to containerize the React app with Nginx serving on port 3000.

Dockerfile:

FROM nginx:1.27-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY dist/ /usr/share/nginx/html
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
Build and test locally:

docker build -t trend-store .
docker run -p 3000:3000 trend-store

3. Terraform Infrastructure

Provisioned AWS infrastructure using Terraform.

VPC + Subnets + IGW

EKS Cluster + Node Group

IAM roles & policies

EC2 Instance for Jenkins
Run commands:

terraform init
terraform plan
terraform apply

4. Jenkins Setup

Installed Jenkins on EC2.

Installed plugins: Docker, GitHub, Kubernetes, Pipeline.

Configured Jenkins to run with Java 17.

Enabled Docker access for Jenkins user.

5. DockerHub Integration

Created a DockerHub repo evanjali1468/trend-store.

Configured Jenkins credentials for DockerHub.

Verified pipeline can push images to DockerHub.

docker login
docker tag trend-store:latest evanjali1468/trend-store:latest
docker push evanjali1468/trend-store:latest

6. Kubernetes Deployment (EKS)

Created Kubernetes manifests:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: trend-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: trend
  template:
    metadata:
      labels:
        app: trend
    spec:
      containers:
      - name: trend
        image: evanjali1468/trend-store:latest
        ports:
        - containerPort: 3000

k8s/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: trend-service
spec:
  type: LoadBalancer
  selector:
    app: trend
  ports:
  - port: 3000
    targetPort: 3000

Deploy:

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

7. CI/CD Pipeline (Jenkinsfile)

Declarative pipeline to build, push, and deploy automatically:

Jenkinsfile

pipeline {
    agent any
    environment {
        DOCKERHUB = credentials('dockerhub-creds')
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Evanjalicloud1/Trend-app-Updated.git'
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
                docker tag trend-store:latest evanjali1468/trend-store:latest
                docker push evanjali1468/trend-store:latest
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}

8. Monitoring (Prometheus + Grafana)

Installed kube-prometheus-stack using Helm.

Exposed Grafana via NodePort/LoadBalancer.

Configured Prometheus as datasource.

Imported Kubernetes / Node Exporter dashboards from Grafana.

LB DNS: http://a5277485312b0409c8181cea4b7502e3-1158258248.ap-south-1.elb.amazonaws.com/

Login default:

user: admin
password: prom-operator

9. Results

Application running on EKS via LoadBalancer DNS.

Jenkins pipeline successful (Build → Push → Deploy).

Docker image available in DockerHub.

Grafana dashboards showing cluster/node metrics.
