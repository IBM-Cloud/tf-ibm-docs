#!/bin/bash

# Pulls IBM Terraform documentation from the IBM fork of terraform:
# https://github.com/IBM-Bluemix/terraform - gets the relevant IBM Cloud
# provider documentation from the repo, and builds a new static site from it
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -e

function cleanup() {
  rm -rf ./terraform
}

# In the event cleanup did not occur on a previous failed run
cleanup

git clone https://github.com/IBM-Bluemix/terraform

# cleanup artifacts before exit
cleanup
exit 0
