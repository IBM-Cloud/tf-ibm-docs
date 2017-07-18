#!/bin/bash

# Pulls IBM Terraform documentation from the IBM fork of terraform:
# https://github.com/IBM-Bluemix/terraform - gets the relevant IBM Cloud
# provider documentation from the repo, and builds a new static site from it
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -ex
PARENT_DIR=$(pwd)

# Gets configuration for scripts; versions, repo, search strings, etc
source config.sh

# Adds arbitrary material to index
# Assumes $INJECT is set to reference the proper page snippet for that version of the docs
function addtoindex() {
  cp ../_inject-schematics.md ../_inject-new.md
  cat ../$INJECT >> ../_inject-new.md
  # TODO: Kelner - this can be fraught with failure if the text changes, and
  # will fail to inject the extra content
  sed "/$INJECT_STRING./r./../_inject-new.md" index.html.markdown > tmp
  mv tmp index.html.markdown
  rm ../_inject-new.md
}

function buildversionlist_legacy() {
  for release in "${LEGACYRELEASES[@]}"; do
    echo "- [$release](/tf-ibm-docs/$release)" >> source/_inject-schematics.md
  done
}

function buildversionlist() {
  for release in "${RELEASES[@]}"; do
    echo "- [$release](/tf-ibm-docs/$release)" >> source/_inject-schematics.md
  done
}

function cleaninject() {
  sed '/<!-- REPLACEME -->/q' source/_inject-schematics.md > tmp
  mv tmp source/_inject-schematics.md
}

# Expects three arguements:
# $1 is the release tag as specified in git, should come from RELEASES
# $2 is the git repo to target, should come from REPO
# $3 is the source path to the documentation for that version of the provider
function getdocs() {
  if [ ! -d "./source/$1" ]; then
    mkdir ./source/$1
  fi
  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi
  if [ ! -d "./terraform/$1" ]; then
    # clone IBM terraform
    git clone --branch $1 $2 --depth=1 ./terraform/$1
    cd ./terraform/$1
  else
    cd ./terraform/$1
    git pull
  fi
  cp -R $3 ../../source/$1
  cd ../../source/$1
  # inject contents into index
  addtoindex
  cd $PARENT_DIR
}

# slightly special function to get the correct documentation for schematics
# Arguments: 
#     $1 is the path to the git repo, either $REPO or $LEGACYREPO
#     $2 is the source path to the documentation for that version of the provider
function getschematicsdocs() {
  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi
  if [ -d "./terraform/schematics" ]; then
    rm -rf ./terraform/schematics
  fi
  git clone --branch $SCHEMATICS_VERSION $1 --depth=1 ./terraform/schematics
  cd ./terraform/schematics
  cp -R $2 ../../source/
  cd ../../source
  # inject contents into index
  sed "/$INJECT_STRING./r./_inject-schematics.md" index.html.markdown > tmp
  mv tmp index.html.markdown
  cd $PARENT_DIR
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

# ensure clean start
preclean

# 1. put all version in index
buildversionlist_legacy
buildversionlist

# 2. pull all releases from IBM GitHub

# process the legacy releases
INJECT="_inject-legacy.md"
for release in "${LEGACYRELEASES[@]}"; do
  getdocs $release $LEGACYREPO "website/source/docs/providers/ibmcloud/*"
done

# process the current releases
INJECT="_inject-v0.4.md"
for release in "${RELEASES[@]}"; do
  getdocs $release $REPO "website/docs/*"
done

# 3. get the version of the docs that the schematic service is using
getschematicsdocs $REPO "website/docs/*"

# build with middleman
bundle install
bundle exec middleman build --clean --verbose

cleanup

# Small hack to make docs work locally
cd build
ln -s . tf-ibm-docs

exit 0
