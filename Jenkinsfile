node {
     stage('Clone repository') {
         checkout scm
     }
     stage('Build image') {
         app = docker.build("621917999036.dkr.ecr.ap-northeast-2.amazonaws.com/web_jenkins")
     }
     stage('Push image') {
         docker.withRegistry('https://621917999036.dkr.ecr.ap-northeast-2.amazonaws.com/web_jenkins', 'Web_ECR') {
             app.push("${env.BUILD_NUMBER}")
             app.push("latest")
         }
     }
}

