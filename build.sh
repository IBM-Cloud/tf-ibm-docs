#!/bin/bash

# Pulls IBM Terraform documentation from the IBM fork of terraform:
# https://github.com/IBM-Bluemix/terraform - gets the relevant IBM Cloud
# provider documentation from the repo, and builds a new static site from it
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -ex
PARENT_DIR=$(pwd)

# Array of iternal releases on https://github.ibm.com/blueprint/bluemix-terraform-provider-dev
INTERNAL_RELEASES=("ibmcloud-v0.1-beta" "ibmcloud-v0.2-beta" \
  "ibmcloud-v0.3-beta" "tf-0.9.3-bluemix-api-key")

# Adds arbitrary material to index
function addtoindex() {
  # TODO: Kelner - this can be fraught with failure if the text changes, and
  # will fail to inject the extra content
  sed '/Use the navigation menu on the left to read about the available resources./r./_inject_developing-locally.md' index.html.markdown > tmp
  mv tmp index.html.markdown
}

# Expects one arguement, the release tag as specified in git
function olddocs() {
  if [ ! -d "./source/$1" ]; then
    mkdir ./source/$1
  fi
  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi
  if [ ! -d "./terraform/$1" ]; then
    # clone IBM terraform
    git clone --branch $1 https://github.ibm.com/blueprint/bluemix-terraform-provider-dev --depth=1 ./terraform/$1
    cd ./terraform/$1
  else
    cd ./terraform/$1
    git pull
  fi
  cp -R website/source/docs/providers/ibmcloud/* ../../source/$1
  cd ../../source/$1
  # inject contents into index
  addtoindex
  cd $PARENT_DIR
}

function cleanup() {
  if [ -d "./source/$1" ]; then
    rm -rf ./source/$1
  fi
  if [ -d "./terraform" ]; then
    # I don't like using `-f` but it is necessary in this case
    # otherwise it will prompt the user for:
    # override r--r--r-- for ./terraform/ibmcloud-v0.1-beta/.git/objects/pack/pack-425f29ccef3ed86df8c2e92b655158da0cefd440.idx?
    # for every .git file
    rm -rf ./terraform
  fi
}

# ensure clean from start
for release in "${INTERNAL_RELEASES[@]}"; do
  cleanup $release
done

# pull all releases from IBM GitHub
for release in "${INTERNAL_RELEASES[@]}"; do
  olddocs $release
done

# build with middleman
bundle install
bundle exec middleman build --clean

# cleanup
for release in "${INTERNAL_RELEASES[@]}"; do
  cleanup $release
done

exit 0
