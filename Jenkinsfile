pipeline {
  agent {
    label 'centos_agent'
  }
  environment {
    LANG = 'en_US.UTF-8'
  }
  stages {
    stage('Build/Test') {
      steps {
        sh 'mix deps.get'
        sh 'mix test'
        junit '_build/test/**/*.xml'
      }
    }
  }
}
