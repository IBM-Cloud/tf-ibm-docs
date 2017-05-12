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
  # kelnerhax - some weird behavior I don't know where-from :)
  # from cleanupsidebar() obviously, and from the sed command, but I'm not
  # a *nix tool expert and couldn't figure it out quickly
  rm -rf ./source/layouts/sidebar.erb-e
}

# cleanup sidebar.erb - can't use as-is
function cleansidebar() {
  grep -v "<% wrap_layout :inner do %>" layouts/sidebar.erb > tmp; mv tmp layouts/sidebar.erb
  grep -v "<% content_for :sidebar do %>" layouts/sidebar.erb > tmp; mv tmp layouts/sidebar.erb
  grep -v "<% end %>" layouts/sidebar.erb > tmp; mv tmp layouts/sidebar.erb
  grep -v "<%= yield %>" layouts/sidebar.erb > tmp; mv tmp layouts/sidebar.erb
  sed -i -e 's/<%= sidebar_current.*%>//g' layouts/sidebar.erb
  grep -v "<a href=\"/docs/providers/index.html\">All Providers</a>" layouts/sidebar.erb > tmp; mv tmp layouts/sidebar.erb
  grep -v "<a href=\"/docs/providers/ibmcloud/index.html\">IBM Cloud Provider</a>" layouts/sidebar.erb > tmp; mv tmp layouts/sidebar.erb
  sed -i -e 's/docs-sidebar hidden-print affix-top/docs-sidebar col-md-2 hidden-print affix-top/g' layouts/sidebar.erb
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
cp website/source/layouts/ibmcloud.erb ../source/layouts/sidebar.erb
cd ../source
cleansidebar
# build with middleman
bundle install
bundle exec middleman build --verbose --clean

# cleanup artifacts before exit
cleanup
exit 0
