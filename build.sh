#!/bin/bash

# Pulls IBM Terraform documentation from the IBM fork of terraform:
# https://github.com/IBM-Bluemix/terraform - gets the relevant IBM Cloud
# provider documentation from the repo, and builds a new static site from it
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -e
PARENT_DIR=$(pwd)

function cleanup() {
  cd $PARENT_DIR
  rm -rf ./terraform
  cd source
  rm -rf d
  rm -rf r
  rm index.md
}

# In the event cleanup did not occur on a previous failed run
cleanup
# clone IBM terraform
git clone https://github.com/IBM-Bluemix/terraform
cd terraform
# switch to the provider team base branch
# As of May 12 2017 it is "provider/ibm-cloud"
git checkout provider/ibm-cloud
cp -R website/source/docs/providers/ibmcloud/ ../source/
# build with middleman
cd ../source
mv index.html.markdown index.md
bundle install
bundle exec middleman build --verbose --clean

# cleanup artifacts before exit
cleanup
exit 0
