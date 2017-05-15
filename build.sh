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
  set +e
  rm -rf ./terraform
  set -e
}

# Adds arbitrary material to index
function addtoindex() {
  # TODO: Kelner - this can be fraught with failure if the text changes, and
  # will fail to inject the extra content
  sed '/Use the navigation menu on the left to read about the available resources./r./_inject_developing-locally.md' index.html.markdown > tmp
  mv tmp index.html.markdown
}

# In the event cleanup did not occur on a previous failed run
cleanup
# clone IBM terraform
git clone https://github.com/IBM-Bluemix/terraform
cd terraform
# switch to the provider team base branch
# As of May 12 2017 it is "provider/ibm-cloud"
git checkout provider/ibm-cloud
cp -R website/source/docs/providers/ibmcloud/ ../source
cd ../source
# inject contents into index
addtoindex
# build with middleman
bundle install
bundle exec middleman build --verbose --clean
cd $PARENT_DIR
# cleanup artifacts before commit & exit
cleanup

exit 0
