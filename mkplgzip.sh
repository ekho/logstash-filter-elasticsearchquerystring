#!/usr/bin/env bash

set -x

JGEM="docker run --rm -v $(pwd)/.gem/bundle:/usr/local/bundle -v $(pwd)/.gem:/root/.gem -v $(pwd):/var/app -w /var/app jruby:9-alpine /opt/jruby/bin/jruby -J-Xmx1024m /opt/jruby/bin/gem"

GEMSPEC=$(ls -1 logstash-filter-*.gemspec | head -n 1)
NAME=$(grep -E "s\.name\s*=" ${GEMSPEC} | sed -e "s/ *//g" -e 's/s.name=//' -e "s/'//g")
VERSION=$(grep -E "s\.version\s*=" ${GEMSPEC} | sed -e "s/ *//g" -e 's/s.version=//' -e "s/'//g")
GEM="${NAME}-${VERSION}.gem"
ZIP="${NAME}-${VERSION}.zip"

if [ ! -f "${GEM}" ]; then
    ${JGEM} build ${GEMSPEC} || exit $?
fi

[ -e "logstash" ] && rm -rf "logstash"
mkdir -p logstash
cp ${GEM} logstash
[ -f "${ZIP}" ] && rm -f ${ZIP}
zip ${ZIP} logstash/*
rm -rf logstash
