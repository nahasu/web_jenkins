node {
    stage('Clone repository') {
        checkout scm
    }

    def customImage

    stage('Build image') {
        customImage = docker.build("621917999036.dkr.ecr.ap-northeast-2.amazonaws.com/web_jenkins:${env.BUILD_NUMBER}")
    }

    stage('Push image to ECR') {
        withAWS(credentials: 'Web_ECR', region: 'ap-northeast-2') {
            docker.withRegistry('', 'ecr:ap-northeast-2:web_jenkins') {
                customImage.push()
                customImage.push("latest")
            }
        }
    }
}
