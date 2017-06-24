pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh '''echo 'Building'

set -x

JGEM="docker run --rm -v $(pwd)/.gem/bundle:/usr/local/bundle -v $(pwd)/.gem:/root/.gem -v $(pwd):/var/app -w /var/app jruby:9-alpine /opt/jruby/bin/jruby -J-Xmx1024m /opt/jruby/bin/gem"

GEMSPEC=$(ls -1 logstash-filter-*.gemspec | head -n 1)
NAME=$(grep -E "s\\.name\\s*=" ${GEMSPEC} | sed -e "s/ *//g" -e 's/s.name=//' -e "s/'//g")
VERSION=$(grep -E "s\\.version\\s*=" ${GEMSPEC} | sed -e "s/ *//g" -e 's/s.version=//' -e "s/'//g")
GEM="${NAME}-${VERSION}.gem"

${JGEM} build ${GEMSPEC}

'''
      }
    }
    stage('publish') {
      steps {
        sh 'echo \'Publishing\''
      }
    }
  }
}
