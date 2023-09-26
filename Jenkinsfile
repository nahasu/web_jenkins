pipeline {
    agent any

    environment{
        REGION = 'ap-northeast-2'
        EKS_API = {https://97E7191BC5E0FBA3B8009BAD384EE126.yl4.ap-northeast-2.eks.amazonaws.com}
        EKS_CLUSTER_NAME = {myeks}
       EKS_JENKINS_CREDENTIAL_ID = 'kubectl-deploy-credentials'
       ECR_PATH = {621917999036.dkr.ecr.ap-northeast-2.amazonaws.com}
       ECR_IMAGE = 'web_jenkins'
       AWS_CREDENTIAL_ID = 'Web_ECR'

    }
    stages {
        stage('Clone Repository'){
            checkout scm
        }
        stage('Docker Build'){
        docker.withRegistry("https://${ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_ID}"){
            image = docker.build("${ECR_PATH}/${ECR_IMAGE}")
            }
        }
        stage('Push to ECR'){
            docker.withRegistry("https://{ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_ID}"){
                image.push("v${env.BUILD_NUMBER}")
            }
        }
        stage('CleanUp Images'){
            sh"""
            docker rmi ${ECR_PATH}/${ECR_IMAGE}:v$BUILD_NUMBER
            docker rmi ${ECR_PATH}/${ECR_IMAGE}:latest
            """
        }
        stage('Deploy to k8s'){
        withKubeConfig([credentialsId: "{EKS_JENKINS_CREDENTIAL_ID}",
                        serverUrl: "${EKS_API}",
                        clusterName: "${EKS_CLUSTER_NAME}"]){
            sh "sed 's/IMAGE_VERSION/v${env.BUILD_ID}/g' service.yaml > output.yaml"
            sh "aws eks --region ${REGION} update-kubeconfig --name ${EKS_CLUSTER_NAME}"
            sh "kubectl apply -f output.yaml"
            sh "rm output.yaml"
             }
        }
}
