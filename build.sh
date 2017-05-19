#!/bin/bash

# Pulls IBM Terraform documentation from the IBM fork of terraform:
# https://github.com/IBM-Bluemix/terraform - gets the relevant IBM Cloud
# provider documentation from the repo, and builds a new static site from it
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -ex
PARENT_DIR=$(pwd)

# Array of iternal releases on https://github.ibm.com/blueprint/bluemix-terraform-provider-dev
INTERNAL_RELEASES=( \
  "ibmcloud-v0.1-beta" \
  "ibmcloud-v0.2-beta" \
  "ibmcloud-v0.3-beta" \
  "tf-0.9.3-bluemix-api-key" \
)
INTERNAL_REPO="https://github.ibm.com/blueprint/bluemix-terraform-provider-dev"

# Array of external releases on https://github.com/IBM-Bluemix/terraform/releases
EXTERNAL_RELEASES=( \
  "tf-v0.9.3-ibm-provider-v0.1" \
  #"tf-v0.9.3-ibm-k8s-v0.1" \
  "tf-v0.9.3-ibm-provider-v0.2" \
  "tf-v0.9.3-ibm-provider-v0.2.1" \
)
EXTERNAL_REPO="https://github.com/IBM-Bluemix/terraform"

# The version of the provider that schematics is using
SCHEMATICS_VERSION="ibmcloud-v0.3-beta"
SCHEMATICS_REPO=$INTERNAL_REPO

# Adds arbitrary material to index
# Takes one argument:
# $1 Boolean: if true, uses old dev local, if false, uses new
function addtoindex() {
  cp ../_inject-schematics.md ../_inject-old.md
  cat ../_inject.md >> ../_inject-old.md
  cp ../_inject-schematics.md ../_inject-new.md
  cat ../_inject-v1.md >> ../_inject-new.md
  if $1; then
    # TODO: Kelner - this can be fraught with failure if the text changes, and
    # will fail to inject the extra content
    sed '/Use the navigation menu on the left to read about the available resources./r./../_inject-old.md' index.html.markdown > tmp
    # TODO: Kelner - cleanup hax, language in old docs is different... see above
    sed '/Use the navigation to the left to read about the available resources./r./../_inject-old.md' index.html.markdown > tmp
    mv tmp index.html.markdown
  else
    sed '/Use the navigation menu on the left to read about the available resources./r./../_inject-new.md' index.html.markdown > tmp
    mv tmp index.html.markdown
  fi
  rm ../_inject-old.md ../_inject-new.md
}

function buildversionlist() {
  echo "#### Internal Schematic Releases" >> source/_inject-schematics.md
  for release in "${INTERNAL_RELEASES[@]}"; do
    echo "- [$release]($release)" >> source/_inject-schematics.md
  done
  echo "" >> source/_inject-schematics.md
  echo "#### Publics Releases" >> source/_inject-schematics.md
  for release in "${EXTERNAL_RELEASES[@]}"; do
    echo "- [$release]($release)" >> source/_inject-schematics.md
  done
}

function cleaninject() {
  sed '/<!-- REPLACEME -->/q' source/_inject-schematics.md > tmp
  mv tmp source/_inject-schematics.md
}

# Expects three arguements:
# $1 is the release tag as specified in git, should come from INTERNAL_RELEASES
# or EXTERNAL_RELEASES
# $2 is the git repo to target, should either be INTERNAL_REPO or EXTERNAL_REPO
# $3 is whether this is internal (true) or not (false)
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
  cp -R website/source/docs/providers/ibmcloud/* ../../source/$1
  cd ../../source/$1
  # inject contents into index
  addtoindex $3
  cd $PARENT_DIR
}

# slightly special function to get the correct documentation for the schematics service
function getschematicsdocs() {
  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi
  if [ ! -d "./terraform/schematics" ]; then
    # clone IBM terraform
    git clone --branch $SCHEMATICS_VERSION $SCHEMATICS_REPO --depth=1 ./terraform/schematics
    cd ./terraform/schematics
  else
    cd ./terraform/schematics
    git pull
  fi
  cp -R website/source/docs/providers/ibmcloud/* ../../source/
  cd ../../source
  # inject contents into index
  sed '/Use the navigation menu on the left to read about the available resources./r./_inject-schematics.md' index.html.markdown > tmp
  mv tmp index.html.markdown
  cd $PARENT_DIR
}

function cleanuprelease() {
  if [ -d "./source/$1" ]; then
    rm -rf ./source/$1
  fi
  # TODO: Maybe remove... would rather leave in place and pull if there...
  #if [ -d "./terraform" ]; then
    # I don't like using `-f` but it is necessary in this case
    # otherwise it will prompt the user for:
    # override r--r--r-- for ./terraform/ibmcloud-v0.1-beta/.git/objects/pack/pack-425f29ccef3ed86df8c2e92b655158da0cefd440.idx?
    # for every .git file
    #rm -rf ./terraform
  #fi
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
  for release in "${INTERNAL_RELEASES[@]}"; do
    cleanuprelease $release
  done
  for release in "${EXTERNAL_RELEASES[@]}"; do
    cleanuprelease $release
  done
  if [ -d "./source/r" ]; then
    rm -r ./source/r
  fi
  if [ -d "./source/d" ]; then
    rm -r ./source/d
  fi
  if [ -f "./source/index.htmk.markdown" ]; then
    rm ./source/index.htmk.markdown
  fi
  cleaninject
}

# ensure clean start
preclean

# put all version in index
buildversionlist

# pull all releases from IBM GitHub
for release in "${INTERNAL_RELEASES[@]}"; do
  getdocs $release $INTERNAL_REPO true
done

# pull all releases from IBM GitHub
for release in "${EXTERNAL_RELEASES[@]}"; do
  getdocs $release $EXTERNAL_REPO false
done

# get the version of the docs that the scematic service is using
getschematicsdocs

# build with middleman
bundle install
bundle exec middleman build --clean --verbose

cleanup

exit 0
