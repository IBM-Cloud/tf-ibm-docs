#!/bin/bash

# Pulls IBM Terraform documentation from the IBM fork of terraform:
# https://github.com/IBM-Bluemix/terraform - gets the relevant IBM Cloud
# provider documentation from the repo, and builds a new static site from it
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -ex
PARENT_DIR=$(pwd)

# Adds arbitrary material to index
function addtoindex() {
  # TODO: Kelner - this can be fraught with failure if the text changes, and
  # will fail to inject the extra content
  sed '/Use the navigation menu on the left to read about the available resources./r./_inject_developing-locally.md' index.html.markdown > tmp
  mv tmp index.html.markdown
}

if [ ! -d "terraform" ]; then
  # clone IBM terraform
  git clone https://github.com/IBM-Bluemix/terraform --depth=1
  cd terraform
else
  cd terraform
  git pull
fi
# switch to the provider team base branch
# As of May 12 2017 it is "provider/ibm-cloud"
git checkout provider/ibm-cloud
cp -R website/source/docs/providers/ibmcloud/* ../source
cd ../source
# inject contents into index
addtoindex
# build with middleman
bundle install
bundle exec middleman build --verbose --clean

exit 0
