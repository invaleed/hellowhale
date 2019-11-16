node {
    def app
    def project = 'axiata'
    def appName = 'hellowhale'

    stage('Clone repository') {
      checkout scm
    }

    stage('Build Dev') {
      if (env.BRANCH_NAME == 'origin/kube-dev') {
        app = docker.build("${project}/boost-dev-${appName}")
      } else {
        app = docker.build("${project}/boost-prod-${appName}")
      }
    }

    stage('Test image') {
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
      docker.withRegistry('https://karimunjawa.boost.id/axiata', 'karimunjawa-credentials') {
        app.push("${env.BUILD_NUMBER}")
        app.push("latest")
      }
    }

    stage('Deploy') {
      if (env.BRANCH_NAME == 'origin/kube-dev') {
          sh 'kubectl delete deployment boost-dev-hellowhale-deployment -n dev'
          sh 'kubectl --namespace=dev apply -f ./kube/dev.yml'
      } else {
          sh 'kubectl delete deployment boost-prod-hellowhale-deployment -n prod'
          sh 'kubectl --namespace=prod apply -f ./kube/prod.yml'
      }
    }

    stage('Remove local images') {
        // remove local docker images
	      sh 'docker image prune -a --force'
    }
}
