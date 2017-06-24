pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh '''echo 'Building'

set -x

JGEM="docker run --rm -v $(pwd)/.gem/bundle:/usr/local/bundle -v $(pwd)/.gem:/root/.gem -v $(pwd):/var/app -w /var/app jruby:9-alpine /opt/jruby/bin/jruby -J-Xmx1024m /opt/jruby/bin/gem"'''
      }
    }
    stage('publish') {
      steps {
        sh 'echo \'Publishing\''
      }
    }
  }
}