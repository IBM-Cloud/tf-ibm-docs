#!/bin/bash

# Pulls IBM Terraform documentation from the IBM fork of terraform:
# https://github.com/IBM-Bluemix/terraform - gets the relevant IBM Cloud
# provider documentation from the repo, and builds a new static site from it
# Copyright (c) 2017 IBM under MIT License

set -ex
PARENT_DIR=$(pwd)

# Gets configuration for scripts; versions, repo, search strings, etc
source config.sh

# $1 is release version
function addtoversionlist() {
    echo "- [$1](/tf-ibm-docs/$1)" >> tmp_version_list.md
}

# Expects three arguements:
# $1 is the release tag as specified in git, should come from RELEASES
# $2 is the git repo to target, should come from REPO
# $3 is the source path to the documentation for that version of the provider
function getdocs() {
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

  if [ ! -d "../../source/$1" ]; then
    mkdir ../../source/$1
  fi
  cp -R $3 ../../source/$1
  cd ../../source

  # inject sidenav
  cp ../_resources/layouts/sidenav-$1.erb ./layouts/sidenav.erb

  cd $PARENT_DIR
}

#
# ----------------------
# MAIN ROUTINE
# $1 is the release version
# ----------------------
#

if [[ $# -eq 0 ]] ; then
    echo "Please enter a release version:"
    for release in "${RELEASES[@]}"
      do
        echo "$release"
    done
    exit 1
fi

function compile() {
  addtoversionlist $1
  getdocs $1 $REPO "website/docs/*"
}
