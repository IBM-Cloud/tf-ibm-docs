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

  grep -v "<% end %>" layouts/sidebar.erb > tmp
  mv tmp layouts/sidebar.erb

  grep -v "<%= yield %>" layouts/sidebar.erb > tmp
  mv tmp layouts/sidebar.erb

  sed -i -e 's/<%= sidebar_current.*%>//g' layouts/sidebar.erb

  grep -v "<a href=\"/docs/providers/index.html\">All Providers</a>" layouts/sidebar.erb > tmp
  mv tmp layouts/sidebar.erb

  sed -i -e 's/<a href=\"\/docs\/providers\/ibmcloud\/index.html\">IBM Cloud Provider<\/a>/<a href=\"\/tf-ibm-docs\/index.html\"><h4>IBM Cloud Provider<\/h4><\/a>/g' layouts/sidebar.erb

  sed -i -e 's/docs-sidebar hidden-print affix-top/docs-sidebar col-md-2 hidden-print affix-top/g' layouts/sidebar.erb

  sed -i -e 's/\/docs\/providers\/ibmcloud/\/tf-ibm-docs/g' layouts/sidebar.erb
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
cp website/source/layouts/ibmcloud.erb ../source/layouts/sidebar.erb
cd ../source
cleansidebar
# inject contents into index
addtoindex
# build with middleman
bundle install
bundle exec middleman build --verbose --clean
# NOTE: This is only for GitHub Pages - if we don't use it, then probably be rid of it
cd $PARENT_DIR
cp -R ./build/. ./docs
# need to move to the gh-pages branch
if [ ! -d "~/tmp" ]; then
  mkdir -p ~/tmp
fi
cp -R ./docs/. ~/tmp/docs
git checkout gh-pages
cp -R ~/tmp/docs/. ./
# cleanup artifacts before commit & exit
cleanup
# push to gh-pages
set +e # allow to continue on error (git exits non-zero when no changes)
git add -A
git commit -m "latest docs"
git push
set -e
# switch back branch
git checkout master
exit 0
