app = docker.build("621917999036.dkr.ecr.ap-northeast-2.amazonaws.com/web_jenkins")

docker.withRegistry('https://621917999036.dkr.ecr.ap-northeast-2.amazonaws.com', 'ecr:ap-northeast-2:Web_ECR')

node {
     stage('Clone repository') {
         checkout scm
     }

     stage('Build image') {
         app = docker.build("621917999036.dkr.ecr.ap-northeast-2.amazonaws.com/web_jenkins")
     }

     stage('Push image') {
         sh 'rm  ~/.dockercfg || true'
         sh 'rm ~/.docker/config.json || true'
         
         docker.withRegistry('https://621917999036.dkr.ecr.ap-northeast-2.amazonaws.com', 'ecr:ap-northeast-2:Web_ECR') {
             app.push("${env.BUILD_NUMBER}")
             app.push("latest")
     }
  }
}
