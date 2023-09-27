pipeline {
    agent any

    environment {
        REGION = 'ap-northeast-2'
        EKS_API = 'https://94A05E3C861DEFA5FFF7409D104C9425.gr7.ap-northeast-2.eks.amazonaws.com'
        EKS_CLUSTER_NAME = 'myeks'
        EKS_JENKINS_CREDENTIAL_ID = 'k8s_token'
        ECR_PATH = '621917999036.dkr.ecr.ap-northeast-2.amazonaws.com'
        ECR_IMAGE = 'web_jenkins'
        AWS_CREDENTIAL_ID = 'Web_ECR'
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    image = docker.build("${ECR_PATH}/${ECR_IMAGE}:latest")
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_ID}") {
                        image.push()
                    }
                }
            }
        }

        stage('Install kubectl') {
            steps {
                sh '''
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod +x kubectl
                    sudo mv kubectl /usr/local/bin/
                '''
            }
        }

        stage('Deploy to k8s') {
            steps {
                script {
                    withKubeConfig([credentialsId: "${EKS_JENKINS_CREDENTIAL_ID}", serverUrl: "${EKS_API}", clusterName: "${EKS_CLUSTER_NAME}"]) {
                        sh "curl https://raw.githubusercontent.com/nahasu/web_jenkins/main/service.yaml > output.yaml"
                        docker.withRegistry("https://${ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_ID}"){
                            sh "docker pull 621917999036.dkr.ecr.ap-northeast-2.amazonaws.com/web_jenkins:latest"
                        }

                        sh "kubectl apply -f output.yaml"
                        sh "rm output.yaml"
                        sh "docker image rm 621917999036.dkr.ecr.ap-northeast-2.amazonaws.com/web_jenkins"
                    }
                }
            }
        }
    }
}
