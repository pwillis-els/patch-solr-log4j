#!/usr/bin/env sh
set -e -u

# NOTE: 

# Set these as environment variables in your shell to override them here
SOLR_VERSION="${SOLR_VERSION:-7.7.3}"
LOG4J_VERSION="${LOG4J_VERSION:-2.16.0}"

[ -e "apache-log4j-${LOG4J_VERSION}-bin.tar.gz" ] || \
    curl -fSL \
        -o "apache-log4j-${LOG4J_VERSION}-bin.tar.gz" \
        "https://dlcdn.apache.org/logging/log4j/${LOG4J_VERSION}/apache-log4j-${LOG4J_VERSION}-bin.tar.gz"

rm -rf "apache-log4j-${LOG4J_VERSION}-bin/"
tar -xvzf "apache-log4j-${LOG4J_VERSION}-bin.tar.gz"

[ -e "solr-${SOLR_VERSION}.tgz" ] || \
    curl -fSL \
        -o "solr-${SOLR_VERSION}.tgz" \
        "https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz"

rm -rf "solr-${SOLR_VERSION}/"
tar -xvzf "solr-${SOLR_VERSION}.tgz"

