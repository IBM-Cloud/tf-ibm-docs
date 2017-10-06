#!/bin/bash

set -ex
PARENT_DIR=$(pwd)

# Gets configuration for scripts; versions, repo, search strings, etc
source config.sh

function cleaninject() {
  sed '/<!-- REPLACEME -->/q' source/_inject-schematics.md > tmp
  mv tmp source/_inject-schematics.md
}

function cleanuprelease() {
  if [ -d "./source/$1" ]; then
    rm -rf ./source/$1
  fi
}

function preclean() {
  if [ -d "./build" ]; then
    rm -rf ./build
  fi
  if [ -d "./docs" ]; then
    rm -rf ./docs
  fi
  cleanup
  cleaninject
}

function cleanup() {
  cd $PARENT_DIR
  for release in "${LEGACYRELEASES[@]}"; do
    cleanuprelease $release
  done

  for release in "${RELEASES[@]}"; do
    cleanuprelease $release
  done

  if [ -d "./source/r" ]; then
    rm -r ./source/r
  fi
  if [ -d "./source/d" ]; then
    rm -r ./source/d
  fi
  if [ -f "./source/index.html.markdown" ]; then
    rm ./source/index.html.markdown
  fi
  cleaninject
}

# build with middleman
bundle install
bundle exec middleman build --clean --verbose

cleanup

# Small hack to make docs work locally
cd build
ln -s . tf-ibm-docs

exit 0
