#!/usr/bin/env bash

set -x

JGEM="docker run --rm -v $(pwd)/.gem/bundle:/usr/local/bundle -v $(pwd)/.gem:/root/.gem -v $(pwd):/var/app -w /var/app jruby:9-alpine /opt/jruby/bin/jruby -J-Xmx1024m /opt/jruby/bin/gem"

GEMSPEC="logstash-filter-esquerystring.gemspec"
VERSION=$(grep -E "s\.version\s*=" ${GEMSPEC} | sed -e "s/ *//g" -e 's/s.version=//' -e "s/'//g")
GEM="logstash-filter-esquerystring-${VERSION}.gem"
ZIP="logstash-filter-esquerystring-${VERSION}.zip"

if [ ! -f "${GEM}" ]; then
    ${JGEM} build ${GEMSPEC} || exit $?
fi

[ -e "logstash" ] && rm -rf "logstash"
mkdir -p logstash
cp ${GEM} logstash
zip ${ZIP} logstash/*
rm -rf logstash
