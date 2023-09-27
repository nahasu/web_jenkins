pipeline {
    agent any

    environment {
        REGION = 'ap-northeast-2'
        EKS_API = 'https://AD8C9492E4BB76B78456947E4E4867D8.yl4.ap-northeast-2.eks.amazonaws.com'
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
                    image = docker.build("${ECR_PATH}/${ECR_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_ID}") {
                        image.push("${env}")
                    }
                }
            }
        }


        stage('Deploy to k8s') {
            steps {
                script {
                    withKubeConfig([credentialsId: "${EKS_JENKINS_CREDENTIAL_ID}", serverUrl: "${EKS_API}", clusterName: "${EKS_CLUSTER_NAME}"]) {
                        sh "curl https://raw.githubusercontent.com/nahasu/web_jenkins/main/service.yaml > output.yaml"
                        sh "aws eks --region ${REGION} update-kubeconfig --name ${EKS_CLUSTER_NAME}"
                        sh "kubectl apply -f output.yaml"
                        sh "rm output.yaml"
                    }
                }
            }
        }
    }
}
